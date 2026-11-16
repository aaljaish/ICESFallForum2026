# ICES Fall Forum 2026 — Presenter script

[Open the presentation](https://aaljaish.github.io/ICESFallForum2026/)


## Slide 1 — Practical AI-assisted research workflows

Good afternoon, welcome everyone. Today I want to show you some of the ways I use AI in my day to day research work. We're going to look at a few things that are easy to start using, and then work our way into more advanced features.

You can scan the QR code or type the short address underneath it into your browser to open the presentation and come back to it after the session.

[Click to reveal your name and affiliation.]

I'm Ahmed Al-Jaishi. I'm an adjunct scientist at ICES and a research scientist at Western University.

[Click to reveal the disclaimer.]

The examples today use public or synthetic information. These are demonstrations, so before you use any of these tools in your own work, make sure you're following your organization's policies and the requirements that apply to your data.

## Slide 2 — Learning objectives

Here's what we're going to cover. I'll build this up one item at a time.

[Click: Language models.]

First, what is a large language model, and how does it actually start putting an answer together?

[Click: Models, effort and usage.]

Then we'll look at different model providers and what goes in choosing a model and its thinking effort. You don't need the most capable model for every single thing you do.

[Click: Scheduled tasks.]

We'll look at tasks that run on a schedule, like a morning calendar check.

[Click: Plugins.]

Then plugins, which let the model work with apps you already use.

[Click: Skills.]

And skills, which save a set of instructions so you don't have to keep typing the same long prompt.

[Click: Play datasets.]

We'll use R to create a synthetic dataset that we can use to plan an analysis and draft code.

[Click: Plan mode and goals.]

Finally, we'll bring those pieces together. We'll make a detailed analysis plan, approve it, and then give the model a specific condition for when the work is complete.

## Slide 3 — Large language models

Before we get into the tools, let's spend a minute on what a large language model is. I want us to have the same starting point, because it helps explain both what these models can do and why we still need to check their work.

## Slide 4 — What is a large language model?

A large language model learns patterns from text. When it generates an answer, it builds that answer one token at a time. A token might be a word, part of a word, or punctuation.

[Click to reveal the survey example.]

Let's use a simple example. We give it the fact that, of ten analysts invited, eight completed the survey. Then we ask, “How many analysts completed the survey?”

The answer hasn't started yet, but the context is already there. It has the survey fact and our question. It uses that context to predict the first token.

[Click “One token.”]

Here, that first token is “Eight.” It hasn't had to invent a starting word out of nowhere. “How many” tells it we're asking for a count, and the fact tells it how many people completed the survey.

[Click “One token” again.]

Now “Eight” is also part of the context. It could be followed by “analysts,” “participants” or “individuals.” In this example, “analysts” has the highest illustrative probability, so that is the token we select.

[Continue clicking “One token,” pausing as the highlighted context changes.]

Then “completed,” then “the,” then “survey,” and finally the period. Each new token gets added to what the model can use for the next prediction.

The highlighting is a simplified way of showing attention: different parts of the available context help with different parts of the answer. These percentages and highlights are illustrative. We're not looking inside a live model here.

[Use “Reset” at any point to clear the answer and return to the first prediction.]

That's also why the information we give it matters. A response can sound fluent without being correct, so we still need to check it against the source.

## Slide 5 — The AI tools you'll encounter

You've probably heard several of these names, and it can get a little confusing because we use the company name, the model name and the app name almost interchangeably.

[Click: OpenAI.]

OpenAI is the company. GPT is the model family, and ChatGPT is the product many of us use to interact with those models.

[Click: Anthropic.]

Anthropic makes Claude. Here, Claude is also the name you'll recognize from the app.

[Click: Google.]

Google has Gemini.

[Click: Perplexity.]

And Perplexity is a service you may have used for searching and getting answers with sources. It uses its own models and models from other providers.

[Click once more to highlight the OpenAI / ChatGPT row.]

For this workshop, I'm focusing on the models offered by OpenAI. But the concepts we're going to discuss apply across model providers. The names, buttons and available features will be different, but the questions we're asking are similar: which model should I use, what information does it need, and how will I check the result?

## Slide 6 — Model choice, thinking effort and usage

All right. Let's start with model choice. There are really two decisions here: which model you want to use, and how much thinking effort you want it to put into the task. Both affect how long the work takes and how much of your usage it consumes.

## Slide 7 — Choose a model for the task

[Click to reveal the simulated model menu.]

When you open the model menu, you'll see several options. You don't have to use the same one for the whole project. I change models depending on what I'm asking it to do.

[Click: Luna.]

Luna is my choice for quick, focused changes. If the task is clear and fairly contained, I often start there. It's fast and economical.

[Click: Sol.]

For a substantial research task, I use Sol. That might involve working through several steps, writing code and checking the output.

[Click: Astra.]

For particularly difficult scientific reasoning or a very complex task, I use Astra.

[Click: Terra and the provider note.]

Terra is another option for writing and visual work. You don't need to memorize all these names. The point is to match the model to the work in front of you. The same approach applies if you're using another provider.

## Slide 8 — Then choose the thinking effort

[Click to reveal the thinking-effort window.]

Once you've chosen a model, you can also choose its thinking effort. These are separate settings. I'm still using the same model, but I'm changing how much reasoning effort it puts into the task.

[Click: My usual Sol settings.]

With Sol, I usually use Medium or High, depending on how much planning, analysis and checking is involved.

[Click: For particularly hard tasks.]

For particularly hard tasks, I use Astra with High effort.

[Click: Time and usage note.]

Higher effort can help with a difficult task, but it can also take longer and use more of your allowance. So I wouldn't automatically turn everything up to the maximum. I want to see whether the extra effort improves the result for the task I'm doing.

[Optional: select a different effort level in the simulated window.]

## Slide 9 — Building a website example

[Click: Build the website.]

As an example, if I'm building a website, I might use Sol with Medium or High effort to get the main structure and behaviour working.

[Click: Refine fonts, colours and placement.]

Once it's working, I might switch to Luna for focused changes. Change this font, move this heading, adjust this colour. Those are much smaller requests.

[Click: Solve especially complex elements.]

If I get to something particularly difficult, I can bring in Astra with High effort to work through it.

So I don't need one model to do absolutely everything. I can use a more capable model where the task calls for it, and a faster model for the smaller changes.

## Slide 10 — Use your allowance where it helps most

The reason this matters is that different tasks don't all consume the same amount of usage. The model, its thinking effort and the complexity of the work all contribute usage.

[Click to reveal the simulated usage window.]

This is an example of where you might check your remaining allowance.
[Optional: click “Manage usage.”]

If you use the most demanding settings for every small edit, you can use up allowance that you might want for a harder task later. I try to save that capacity for the work where it makes a difference.

## Slide 11 — Scheduled tasks

The next thing I want to show you is scheduled tasks.

## Slide 12 — What is task scheduling?

Scheduled tasks are exactly what they sound like. They're tasks that run at a time you choose. That could be once, or it could be something that repeats every weekday or every week.

[Click to reveal the calendar prompt.]

Here's a practical example. Every morning, I want it to read my connected Outlook calendar and summarize the day. List my meetings in time order. If a meeting is online, give me the join link. If it's in person, tell me where I need to go.

I've also asked it to check whether I have enough time to walk there from my office or the previous meeting. That makes the brief more useful than just copying a list of appointments.

I also get it to flag any missing details. If the location or join link isn't there, I ask the model to let me know.

## Slide 13 — Scheduled tasks

Another task I use is a weekly methods scan. To keep up with the literature, I ask my chatGPT account to search for relavent papers recently published.

[Click to reveal the prompt.]

In this example, I'm interested in pragmatic trials and cluster randomized trials. I've told it which kinds of sources to prioritize, and to pay attention to registry-based designs when they're relevant.

I'm also limiting the output to the top three to five items. I don't want a huge list that I won't read. For each item, I want to know why it matters, what the methods takeaway is, and what caveats I should keep in mind.

I would still open the sources and check anything I planned to use. The scheduled task helps me find and organize the material.

## Slide 14 — The weekday calendar brief

Here's what setting up that calendar task could look like. This is a simulated page, and the meetings are obviously fictional.

The task runs every weekday at eight in the morning. I've given it a name and the instructions for what the brief should contain.

[Open “Advanced.”]

Under Advanced, I can choose whether each run goes into a new chat or an existing chat. A new chat gives me a separate thread each time. An existing chat keeps the briefs together. For me, that's mostly a preference about how I want to organize them.

I can also choose a project. For example, I could put all these recurring tasks into one project so they're easy to find.

Then I choose the model and reasoning effort. This example uses Luna with Max reasoning. For a well-defined task like this, I'd try that setup and check whether the briefs are doing what I need.

[Click “Save” to reveal the example brief.]

Now I can see my day at a glance: an in-person huddle, some writing time, and an online meeting with patient partners. The useful part is having the information I need in one place before the day starts.

## Slide 15 — Plugins

All right. Next are plugins. These give ChatGPT tools for working with other apps. So instead of only working with what I type or upload, it can work with information in an account I've connected.

## Slide 16 — Plugins for the apps you use

Here's the plugin window. You can search for the apps you already use and see which connections are available in your setup.

You might want Google Drive for documents and spreadsheets, Gmail for email, Google Calendar for meetings, or GitHub for code and project issues. There are also examples here like Asana, Notion, Linear and Dropbox.

The point is that the plugin gives the model tools to interact with that service, within the access you've allowed. The exact things it can do depend on the plugin.

[Click Gmail.]

If I open Gmail, I get a page describing what I can use it for, along with some example requests.

[Click “Connect.”]

Then there's a connection step where I review the access. This is just a simulation using a fictional inbox.

[Click “Connect Gmail” in the dialog.]

Once that connection is in place, I can ask a question about my email. Let's look at an example.

[Click “Try now” to move to the inbox slide.]

## Slide 17 — Checking email with Gmail

Let's say I'm working on Trial XYZ and I want to know which emails need a reply, and by when.

There are three fictional messages here. One asks for feedback on a recruitment flyer. One asks me to confirm a training session. And one is just a recruitment update.

My prompt is, “Check my Gmail for Trial XYZ emails. Which ones need a reply, and by when?”

[Click to reveal the summary.]

Now I have two actions: send feedback by noon Thursday, and confirm the training by Friday. The recruitment update doesn't ask for a reply.

That's a fairly simple example, but it's useful. It has taken the information in those messages and organized it around the question I actually asked. At this point, it hasn't sent a response. It's helped me figure out what needs my attention.

## Slide 18 — Skills

The next thing I want to talk about is skills. These are useful when you keep doing the same kind of task, but it doesn't necessarily happen on a schedule. It's a workflow you want to reuse whenever you need it.

## Slide 19 — Using /skills

If you find yourself typing out the same long instructions again and again, that might be a good candidate for a skill. You save those instructions once, then use them when you have a new draft, paper or dataset to work with.

Here's a simulated skills window. Humanizer is one example, and we'll look at that in a minute. I've also included two examples that could be useful for researchers and analysts.

[Click “Evidence extraction.”]

For evidence extraction, I might want the same fields from every paper: the study design, population, exposure, comparator, outcome and estimate. The skill can also tell it to include where the information came from and mark anything that wasn't reported.

[Close the dialog. Click “Dataset quality check.”]

For a dataset quality check, I might want it to look for missing values, values outside the expected range and repeated IDs. The instructions should tell it what one row represents, because a repeated ID isn't always an error.

[Close the dialog. Click “Skill Creator.”]

You can also create your own. Here, I'm saving some instructions for editing a project update in plain language. I can change those instructions and then create the skill.

[Click “Create skill,” show the saved instructions, then close the dialog.]

In an interface that supports slash commands, I can type a slash and select an installed skill. The idea is that I don't have to paste the whole set of instructions every time.

## Slide 20 — A published writing skill

You don't always have to create a skill yourself. People publish them, and you can review one that's already available.

Here's the example I mentioned: Humanizer, from the GitHub account Blader.

[Click to reveal the simulated prompt.]

I can give the model the repository link and ask it to review the skill's instructions and supporting files. In this prompt, I'm asking it to look for security, privacy and unintended behaviour risks.

[Click to reveal the installation condition.]

Then I make the installation conditional on that review, and I ask it to install the skill in this project only. If it finds a concern, I want it to explain that before proceeding. I also want a summary of what it checked and anything it's still uncertain about. A review doesn't guarantee that something is risk-free.

[Click “Open the full SKILL.md on GitHub.” Return to the presentation when ready.]

This link lets us look at the actual instructions. The page on the slide is a simulation; we're not installing anything during this demonstration.

## Slide 21 — Humanizer edits a results paragraph

Here's a short example of what I mean by making the writing sound more natural. This is a fictional results paragraph about analysts using a new codebook.

The first version starts, “It is worth noting,” and later says, “An important caveat warrants consideration.” Those phrases add quite a lot of wording without adding much information.

The revised version says: “Of the 50 analysts who responded, 36 said the new codebook helped them find variables faster. We did not time their searches.”

That's much closer to how I would write it. It's shorter, easier to read, and it still includes the limitation. I would check the revision against the original before using it, especially the numbers and any scientific wording.

## Slide 22 — Play datasets

Now I want to move into an example that's closer to analytic work. Sometimes I want to plan an analysis or start writing code before I'm working with the actual data. A synthetic, or play, dataset can help with that.

## Slide 23 — My prompt for a play dataset

This is the prompt I used to ask for a synthetic dataset in R.

The example is a hospital encounter within 30 days after an index hospitalization for myocardial infarction. That encounter could be an emergency department visit or a rehospitalization. I specified a binary outcome, called Outcome, with a prevalence of 20 percent.

[Click to show the six covariates.]

Then I listed the variables I wanted: age, sex, diabetes, chronic kidney disease, hypertension and income quintile. I've given it the variable names and coding, along with some ranges and prevalences.

Being specific here helps. If I already know the structure I expect, I can ask it to generate something that matches that structure.

[Click to show the correlation and file instructions.]

I've also asked it to induce some correlation between the covariates, and between the covariates and the outcome. That gives us more to work with than completely unrelated columns.

Finally, I asked for the R code and the CSV, and told it to ask questions before creating the dataset. For example, it would need to know how many observations I want.

These are made-up records. We can use them to develop the workflow and draft code, but the results don't tell us what happens in a real patient population.

## Slide 24 — Plan mode

Now that we have a play dataset, let's use it to plan an analysis. This is where I want to pause before asking the model to write and run a lot of code. I want to agree on what we're doing and what the output should contain.

## Slide 25 — Plan the analysis with Astra High

For this part, I'm using Astra with High effort. I want it to work through the analysis plan before we move into implementation.

The question is how the six covariates relate to the odds of a hospital encounter within 30 days.

Notice the prompt says that the included CSV is synthetic. And the sentence underlined in yellow is important: the plan and resulting R code should be reusable for another dataset with a similar structure and variables. I don't want it building code around the particular values or results in this example file.

I'm asking it to specify the tables, plots, assumption checks and interpretation, with everything going into one HTML report.

[Click “Draft analysis plan.”]

The first step is to validate the input. Does the file have the expected variables and coding? What is missing? How many encounters are there?

[Click: Descriptive summaries.]

Then we explore the data, including summaries by outcome and plots of the distributions and relationships.

[Click: Regression.]

Next, fit the regression and report the adjusted odds ratios with their uncertainty.

[Click: Checks.]

Then check whether there are problems with the fit or the data that affect how we should interpret it.

[Click: Interpretation and report.]

And finally, put the interpretation and reproducible analysis into the report.

[Optional: open “Read detailed plan,” then close it.]

I would review this plan and ask for changes before approving it. The model can help develop the plan, but I still need to decide whether it answers the research question.

[Click “Approve plan and switch to Sol.”]

## Slide 26 — Give Sol an approved analysis plan

Now we've switched to Sol with High effort. Astra helped us work through the plan. Sol is going to use those agreed decisions to write and run the analysis.

The model specification is shown here. We're including all six covariates, expressing age per ten years, and treating income quintile as categorical, with quintile one as the reference.

The instruction is to follow the approved plan and assemble the report. The code still needs to check the dataset it receives and calculate the results from that file.

[Click “Review deliverables.”]

First, we need the input validation and a clear outcome definition.

[Click: EDA.]

Then the descriptive tables and exploratory plots.

[Click: Estimates.]

The adjusted odds ratios and a forest plot.

[Click: Diagnostics.]

The diagnostics and sensitivity checks specified in the plan.

[Click: Interpretation and code.]

And the interpretation, analysis code and session information.

Now we've got a concrete list of what needs to be in the report. That gives us a useful stopping condition for the next feature.

[Click “Set a completion goal.”]

## Slide 27 — Goals with /goal

All right. The next thing I want to show you is /goal. This is for work where you want the agent to keep going toward a defined outcome. And because we've already approved a plan, we have a clear way to say what finished should look like.

## Slide 28 — Stop when the report is complete

A goal needs a stopping condition. You could give the model something subjective, like “keep improving this until you think it's ready.” But for this example, we can be much more specific.

The goal is to execute the approved EDA and logistic regression plan and create the HTML report. It should contain every planned item, and the model should open it and check the tables, plots and interpretation before marking the task complete.

So just creating a file with the right name isn't enough. We want evidence that the contents match the plan.

I've also included a time limit. If three hours pass first, report the progress and list anything unfinished. That's a limit on the request, rather than permission to drop the unfinished items and call the analysis complete.

[Optional: open “Review the detailed plan,” then close it.]

The plan tells it what to do. The goal tells it what outcome to work toward and when to stop. I would still review the report myself before relying on it.

[Click “Try this goal.”]

## Slide 29 — The goal produces a reviewable report

Here's the simulated workflow using Sol High.

[Click the /goal shortcut, or type /goal in the message field.]

That brings up the goal prompt. It includes the report we want, the checks it needs to complete and the time limit.

[Click “Start simulated goal.”]

Now it's working through the approved plan. In this demonstration, each click shows another deliverable being checked. We're not running an analysis in the slide itself.

[Click “Check the next deliverable.”]

First, validate the input data.

[Click again.]

Then explore the distributions and relationships.

[Click again.]

Fit the logistic regression.

[Click again.]

Complete the model checks and sensitivity analyses.

[Click again to show the completed report state.]

And finally, render the HTML and open it to check the output. The example here has 1,000 synthetic records and 200 encounters. The report brings together the tables, plots, estimates, diagnostics and interpretation.

That's the workflow I wanted to show you: use play data to get started, use a capable model to help develop the plan, and then give the implementing model a clear set of deliverables and a stopping condition. What I get at the end is something I can open, inspect and review.

## Slide 30 — Thank you

Thank you, everyone. I hope this gave you a few things you can try in your own research work. You can scan the QR code or use the address below it to access the presentation. And if you'd like to get in touch, my email is aaljaish@uwo.ca.

And I’ll leave you with this: AI promised to make my life easier, and now I spend 45 minutes crafting the perfect prompt to avoid a task that would’ve taken me 10.

I'm happy to take questions.
