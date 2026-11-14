# Run Rscript analyze_mi_encounters.R. Requires only R's standard packages.
# All findings describe the supplied synthetic play dataset.
script_arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
folder <- if (length(script_arg)) dirname(normalizePath(sub("^--file=", "", script_arg[1]))) else getwd()
input <- file.path(folder, "mi_encounters.csv")
output <- file.path(folder, "mi_analysis_report.html")
d <- read.csv(input)
expected <- c("Outcome", "age", "sex", "dm", "ckd", "htn", "incomeQuintile")
stopifnot(identical(names(d), expected), nrow(d) == 1000, !anyNA(d),
          all(d$age >= 18 & d$age <= 105), sum(d$Outcome) == 200)
for (v in c("Outcome","sex","dm","ckd","htn")) stopifnot(all(d[[v]] %in% 0:1))
stopifnot(all(d$incomeQuintile %in% 1:5))
missing <- data.frame(Variable=names(d), Missing=colSums(is.na(d)))
repeated <- sum(duplicated(d))
raw <- d
d$incomeQuintile <- factor(d$incomeQuintile, levels=1:5)
d$age10 <- (d$age - 68)/10
formula_main <- Outcome ~ age10 + sex + dm + ckd + htn + incomeQuintile
model_warnings <- character()
fit_model <- function(formula, data) {
  withCallingHandlers(glm(formula, data=data, family=binomial(), na.action=na.fail),
    warning=function(w) {
      model_warnings <<- c(model_warnings, conditionMessage(w))
      invokeRestart("muffleWarning")
    })
}
fit <- fit_model(formula_main, d)
spline <- fit_model(Outcome ~ splines::ns(age, df=3) + sex + dm + ckd + htn + incomeQuintile, d)
stopifnot(fit$converged, spline$converged, all(is.finite(coef(fit))), all(is.finite(vcov(fit))))
comparison <- anova(fit,spline,test="LRT")
nonlinear_p <- comparison[2,"Pr(>Chi)"]
coef_table <- summary(fit)$coefficients[-1,,drop=FALSE]
terms <- c("Age, per 10 years", "Male vs female", "Diabetes, yes vs no",
           "CKD, yes vs no", "Hypertension, yes vs no",
           "Income Q2 vs Q1", "Income Q3 vs Q1", "Income Q4 vs Q1", "Income Q5 vs Q1")
odds <- data.frame(Comparison=terms, OR=exp(coef_table[,1]),
                  Lower=exp(coef_table[,1]-1.96*coef_table[,2]),
                  Upper=exp(coef_table[,1]+1.96*coef_table[,2]))
prob <- fitted(fit)
events <- sum(d$Outcome)
auc <- (sum(rank(prob)[d$Outcome==1])-events*(events+1)/2)/(events*(nrow(d)-events))
brier <- mean((d$Outcome-prob)^2)
decile <- pmin(10, ceiling(rank(prob,ties.method="first")/(nrow(d)/10)))
calibration <- aggregate(cbind(Predicted=prob, Observed=d$Outcome), list(Decile=decile), mean)
X <- model.matrix(fit)[,-1,drop=FALSE]
vif <- diag(solve(cor(X)))
cook <- cooks.distance(fit)
largest <- which.max(cook)
sensitivity <- fit_model(formula_main,d[-largest,])
change <- max(abs(coef(sensitivity)[-1]-coef(fit)[-1]))
validation <- data.frame(Check=c("Rows","Outcome = 1","Outcome = 0","Missing cells","Age range","Repeated full rows"),
                         Result=c(nrow(d), events,nrow(d)-events,sum(is.na(d)),paste(range(d$age),collapse=" to "),repeated))
categories <- do.call(rbind,lapply(c("sex","dm","ckd","htn","incomeQuintile"),function(v) {
  do.call(rbind,lapply(sort(unique(raw[[v]])),function(k) {
    rows <- raw[[v]]==k
    data.frame(Variable=v,Level=k,N=sum(rows),Events=sum(d$Outcome[rows]),Rate=mean(d$Outcome[rows]))
  }))
}))
age_summary <- do.call(rbind,lapply(c("All","0","1"),function(g) {
  x <- if(g=="All") d$age else d$age[d$Outcome==as.integer(g)]
  data.frame(Group=g,N=length(x),Mean=mean(x),SD=sd(x),Median=median(x),Q1=quantile(x,.25),Q3=quantile(x,.75),Min=min(x),Max=max(x))
}))
corr <- round(cor(raw[,c("age","sex","dm","ckd","htn")]),2)
diagnostics <- data.frame(Check=c("Main model convergence","Design rank / columns","Coefficient SE range",
 "Fitted probability range","Age spline comparison, 2 additional df","Largest design-column VIF",
 "Largest Cook's distance / row","Max absolute log-OR change after removing that row","Apparent AUC","Apparent Brier score"),
 Result=c(fit$converged,paste(fit$rank,ncol(model.matrix(fit)),sep=" / "),
 paste(round(range(coef_table[,2]),3),collapse=" to "),paste(round(range(prob),3),collapse=" to "),
 format.pval(nonlinear_p,digits=3),round(max(vif),2),paste(round(max(cook),4),largest,sep=" / "),
 round(change,3),round(auc,3),round(brier,3)))
escape <- function(x) {
  x <- gsub("&","&amp;",as.character(x),fixed=TRUE)
  x <- gsub("<","&lt;",x,fixed=TRUE)
  gsub(">","&gt;",x,fixed=TRUE)
}
table_html <- function(x, caption) {
  cells <- lapply(x,function(v) if(is.numeric(v)) format(round(v,3),trim=TRUE) else v)
  rows <- apply(as.data.frame(cells),1,function(r) paste0("<tr><td>",paste(escape(r),collapse="</td><td>"),"</td></tr>"))
  paste0("<table><caption>",escape(caption),"</caption><thead><tr><th>",paste(escape(names(x)),collapse="</th><th>"),
         "</th></tr></thead><tbody>",paste(rows,collapse=""),"</tbody></table>")
}
plot_svg <- function(draw, label) {
  f <- tempfile(fileext=".svg")
  svg(f,width=9,height=4.3,pointsize=12)
  par(mar=c(5,6,3,2), mgp=c(4,1,0))
  draw()
  dev.off()
  lines <- readLines(f,warn=FALSE)
  unlink(f)
  lines <- lines[seq(which(grepl("<svg ",lines))[1],length(lines))]
  # Each inline figure needs its own glyph and clipping identifiers.
  prefix <- paste0(gsub("[^a-zA-Z]","",label),"-")
  lines <- gsub('id="',paste0('id="',prefix),lines,fixed=TRUE)
  lines <- gsub('href="#',paste0('href="#',prefix),lines,fixed=TRUE)
  lines <- gsub('url(#',paste0('url(#',prefix),lines,fixed=TRUE)
  paste0('<figure role="img" aria-label="',label,'">',paste(lines,collapse="\n"),'<figcaption>',label,'</figcaption></figure>')
}
age_plot <- plot_svg(function() {
  hist(d$age,breaks=seq(15,110,5),col="#a6d6e5",border="white",main="Age distribution",xlab="Age (years)",ylab="Index hospitalizations")
}, "Age histogram in five-year intervals")
forest <- plot_svg(function() {
  par(mar=c(5,12,2,2))
  y <- rev(seq_len(nrow(odds)))
  plot(odds$OR,y,log="x",xlim=range(c(odds$Lower,odds$Upper)),yaxt="n",ylab="",xlab="Adjusted odds ratio (log scale)",pch=19,col="#151d5d")
  axis(2,at=y,labels=terms,las=1,cex.axis=.8)
  segments(odds$Lower,y,odds$Upper,y,col="#151d5d",lwd=2)
  abline(v=1,lty=2,col="grey")
}, "Adjusted odds ratios and 95% Wald confidence intervals")
cal_plot <- plot_svg(function() {
  plot(calibration$Predicted,calibration$Observed,xlim=c(0,1),ylim=c(0,1),pch=19,
       col="#151d5d",xlab="Mean predicted probability",ylab="Observed encounter proportion",
       main="Apparent calibration by prediction decile")
  abline(0,1,lty=2,col="grey")
}, "Calibration in the same sample used to fit the model")
age_curve <- plot_svg(function() {
  ages <- seq(min(d$age),max(d$age),length.out=70)
  standardize <- function(m) vapply(ages,function(a) {
    nd <- d; nd$age <- a; nd$age10 <- (a-68)/10
    mean(predict(m,newdata=nd,type="response"))
  },numeric(1))
  linear <- standardize(fit); flexible <- standardize(spline)
  plot(ages,linear,type="l",ylim=range(c(linear,flexible)),lwd=2,col="#151d5d",
       xlab="Age (years)",ylab="Standardized encounter probability")
  lines(ages,flexible,col="#a65b00",lwd=2,lty=2)
  rug(d$age,col="#00000025")
  legend("topleft",c("Linear age","Natural spline, 3 df"),col=c("#151d5d","#a65b00"),lty=1:2,lwd=2,bty="n")
}, "Age functional-form sensitivity, standardized over the covariate distribution")
ckd <- odds[odds$Comparison=="CKD, yes vs no",]
warnings_text <- if(length(model_warnings)) paste(unique(model_warnings),collapse="; ") else "No warnings from the fitted models."
coverage <- data.frame(
 Plan_item=c("1. Validate inputs","2. Explore data","3. Fit logistic regression","4. Check the model","5. Interpret and deliver"),
 Evidence=c("Schema, ranges, event counts, missingness and repeated rows",
 "Age summary and histogram, categorical distributions by outcome, correlations",
 "All six covariates, income as a factor, adjusted odds ratios and intervals",
 "Age spline, rank and collinearity, convergence, sparse cells, influence, apparent calibration",
 "Plain-language CKD example, limitations, full code and session information"))
html <- c('<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Synthetic MI encounter analysis</title>',
'<style>body{font:17px/1.55 system-ui,sans-serif;color:#202941;max-width:1050px;margin:0 auto;padding:45px 30px}h1,h2,h3{color:#151d5d}h1{font-size:40px;line-height:1.15}h2{border-top:2px solid #daedf6;padding-top:28px;margin-top:45px}a{color:#254b8f}table{border-collapse:collapse;width:100%;margin:20px 0 30px}th,td{padding:9px;text-align:left;border-bottom:1px solid #ddd}caption{text-align:left;font-weight:650;margin-bottom:8px}thead{background:#eef5f8}pre{white-space:pre-wrap;overflow-wrap:anywhere;background:#f5f6f8;padding:20px;font-size:13px}figure{margin:26px 0}svg{width:100%;height:auto}figcaption{font-size:14px;color:#555}.lead{font-size:21px}.note{border-left:5px solid #ffc13a;padding-left:18px}nav{display:flex;gap:20px;flex-wrap:wrap}</style></head><body>',
'<h1>30-day hospital encounters after myocardial infarction</h1><p class="lead">EDA and logistic regression using 1,000 synthetic index hospitalizations.</p>',
'<p class="note">Play data for analytic planning and code development. The generator fixes 200 outcomes and induces associations by design. These estimates describe this simulation.</p>',
'<nav><a href="#validation">Validation</a><a href="#eda">EDA</a><a href="#model">Model</a><a href="#checks">Checks</a><a href="#interpretation">Interpretation</a><a href="#reproduce">Reproduce</a></nav>',
table_html(coverage,"Approved plan and report coverage"),
'<h2 id="validation">1. Input validation and outcome definition</h2>',
'<p>One row represents an index hospitalization for myocardial infarction. Outcome = 1 means any ED visit or rehospitalization within 30 days of discharge. Outcome = 0 means neither event in that window. The CSV contains a combined binary outcome and six baseline covariates. ED visits and rehospitalizations cannot be separated with these fields.</p>',
table_html(validation,"Input checks"),table_html(missing,"Missing values by field"),
'<p>Repeated full rows can occur because the recorded characteristics are coarse. They are retained. There is no patient identifier, so repeat admissions within the same person cannot be checked. Independent rows and complete 30-day ascertainment are simulation assumptions. A real-data protocol must define index admissions, repeat patients, deaths, follow-up eligibility and outcome ascertainment.</p>',
'<h2 id="eda">2. Exploratory data analysis</h2>',
table_html(age_summary,"Age overall and by Outcome"),
age_plot,table_html(categories,"Categorical distributions and encounter proportions"),
'<p>sex = 0 female, 1 male. dm, ckd and htn use 0 absent, 1 present. Income quintile 1 is lowest and 5 highest. Rates are proportions. No univariable significance screening is used to select covariates.</p>',
table_html(data.frame(Variable=rownames(corr),corr,check.names=FALSE),"Pearson correlations for age and binary covariates"),
'<p>Income is summarized as categorical. Correlations reflect the dependence built into the generator.</p>',
'<h2 id="model">3. Prespecified logistic regression</h2>',
'<pre>Outcome ~ age10 + sex + dm + ckd + htn + factor(incomeQuintile)</pre>',
'<p>The binomial model uses a logit link. age10 = (age − 68) / 10, so its odds ratio is per ten-year increase. All six covariates enter together. Reference groups are female, no history of each condition, and income quintile 1. This is a descriptive association model for the composite outcome.</p>',
table_html(odds,"Adjusted odds ratios and 95% Wald confidence intervals"),forest,
'<h2 id="checks">4. Model checks and sensitivity analyses</h2>',table_html(diagnostics,"Diagnostics"),
paste0('<p>',escape(warnings_text),'</p>'),
'<p>Check the categorical tables for sparse outcome cells, and the rank, standard errors and fitted probabilities for instability or separation signals. These checks are screening evidence. Design-column VIFs measure dependence among the encoded predictors, including income dummy columns.</p>',
table_html(data.frame(Design_column=names(vif),VIF=as.numeric(vif)),"Collinearity by model column"),
age_curve,
paste0('<p>The age sensitivity replaces the linear age term with a natural cubic spline (3 df). The likelihood ratio comparison has p = ',format.pval(nonlinear_p,digits=3),
 '. Both fits are reported. The primary specification remains the prespecified linear model; differences across the age range should be considered with the histogram and sparse tails.</p>'),
'<p>The largest Cook’s distance identifies one row for a sensitivity refit. The diagnostic table reports the maximum absolute change in a covariate log-odds coefficient after its removal. The primary analysis retains that row.</p>',
cal_plot,table_html(calibration,"Prediction deciles, 100 rows per group"),
'<p>AUC, Brier score and calibration are apparent performance evaluated in the fitting sample. External or resampling validation would be needed for a prediction tool.</p>',
'<h2 id="interpretation">5. Interpretation and completion</h2>',
sprintf('<p>In these synthetic records, CKD is associated with %.2f times the odds of a 30-day encounter (95%% CI %.2f–%.2f), adjusting for the other covariates. This is an odds comparison, and cannot be read as the same fold change in probability.</p>',ckd$OR,ckd$Lower,ckd$Upper),
'<p>The generator uses illustrative risk weights and exact marginal event counts. It provides a way to draft an analysis workflow, check code, and review reporting choices. Clinical inference would require an appropriate real-data study design and its own assessment of confounding, selection and measurement.</p>',
'<p>All five approved items have corresponding sections above. Completion requires an HTML file that opens, contains the tables and embedded plots, and documents the checks and unresolved assumptions.</p>',
'<h2 id="reproduce">Reproducibility</h2><p>Input checksum (MD5) ',unname(tools::md5sum(input)),
'. Run <code>Rscript analyze_mi_encounters.R</code> in this folder to rebuild the report. It uses base R and the recommended splines package.</p>',
'<details><summary>Analysis R source</summary><pre>',escape(paste(readLines(file.path(folder,"analyze_mi_encounters.R"),warn=FALSE),collapse="\n")),'</pre></details>',
'<details><summary>R session information</summary><pre>',escape(paste(capture.output(sessionInfo()),collapse="\n")),'</pre></details>',
'<p>Method reference · <a href="https://stat.ethz.ch/R-manual/R-devel/library/stats/html/glm.html">R documentation for generalized linear models</a></p></body></html>')
writeLines(html,output,useBytes=TRUE)
stopifnot(file.exists(output), file.info(output)$size > 10000)

cat("Report generated:",output,"\n")
cat("Age spline p:",nonlinear_p,"CKD OR:",ckd$OR,"AUC:",auc,"\n")
