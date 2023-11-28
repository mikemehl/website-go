---
title: Actix + Askama + HTMX + Typst = Single Binary Resume Website
description: Building a single binary resume website while reducing developer friction.
date: 2023-11-09
tags: [rust, webdev, actix, askama, htmx, typst, resume, software]
---

## Intro: Why I Wrote This

I am a firmware engineer by day, but by night I play around with many other fields within software engineering. Recently, I revamped my personal website to use [Actix](https://actix.rs/), [Askama](https://djc.github.io/askama/) and [HTMX](https://htmx.org/). I am very happy with the result, so I thought I'd do a little write-up on it.

## Preparation: What I Want From My Website

I've hosted a website to display my resume for years, and decided mine needed a major makeover. Previously, I've used jekyll, raw HTML+CSS, and my own static site generators in Python and Fennel. All of these worked, but were not quite comfortable to me for several reasons.

1. Jekyll is probably the least opinionated of the static site generators I've used, but I still found it to be too opinionated for my tastes. It's really geared towards blog hosting, but I didn't want a blog. You can do some stuff to work around it and make it do whatever you need, but it's not ideal. I also found it to be a bit slow.
2. Raw HTML+CSS is fine, but I don't want to keep my resume in HTML. Ideally, I want to keep a single configuration file (in TOML or YAML) that contains all of my resume information, and then have a template that renders it to HTML. 
3. My own static site generators were better, because I was able to craft them to my specific needs, until I started wanting to add some dynamic content. This isn't really the fault of the static site generators, and I'd recommend them for simple sites that just need to convey information or host a canned blog. Really, what I wanted was that dynamic content without having to write a ton of javascript.

So, when I decided to revamp my website, I decided it would be best to use a framework that could handle the dynamic content for me.

## First Steps: Feeling Out the Options

Initially, I started with the idea of having an SQLite database with all of my resume info. SQLite is wonderful for low scale and embedded use cases, and the model of having your database in a single file means deployment would be easy. I started implementing my website with this idea in mind. I also wanted to use Rust, since I don't get many opportunities to, and I feel pretty comfortable with the language.

I went through the [are we web yet](https://www.arewewebyet.org/) site and found Actix. After some googling, it seemed like the standard backend web server for Rust projects, so I added it to my cargo project and started coding. It was extremely easy to get up to speed with. I set up my database schema, along with some raw SQL scripts to fill my database, and started working. This is where I noticed a few points of friction:

1. The additional scripting to translate my resume from a YAML file to SQL was a bit annoying. I could have written a program to do this, but I didn't want to have to maintain that. Maintaining a single YAML file is much easier.
2. I started writing views and templates, and quickly realized that having SQLite for read only data was overkill. It meant introducing extra abstractions to retrieve data that I already had in a very structured format, and restructuring it within the backend. Lame.

## Friendship Ended with SQLite, Serde + Askama is My New Best Friend

I googled around looking for options to replace my SQLite portion with a simple templating system. Askama popped up, and it looked like exactly what I wanted. I could keep my resume in a YAML file, and then write a template to render it to HTML. Bonus points: built in Actix and Serde support. All I had to do was create some structs with the right traits, and I'd be able to read in my YAML file and render it to HTML. Perfect!

But, it gets even better. One of the nice things about Askama, is that it compiles all of your templates **into your binary**. Couple that with Rust's ability to embed a file's contents as a string at compile time, and you end up with a single static binary for your entire website. No need to worry about deploying a database, template files, structured data, etc. Just a single binary for your backend. Slap a reverse proxy in front of it, and you're done. This is exactly what I wanted.

## Death To Javascript, Long Live HTMX

Now that I had a backend cooking, my site was coming along nicely. However, there was one more piece I really wanted to play with: [HTMX](https://htmx.org). I'd watched [the primeagen's](https://www.youtube.com/c/theprimeagen) videos on it and had been dying for an excuse to check it out. If you don't know, HTMX provides an incredibly simple and convenient way to perform AJAX requests without writing a single line of Javascript. You simply include the script, and some additional attributes to your HTML tag, and HTMX will take care of the rest. There's even a special `hx-boost` attribute that will convert all anchor tags to use HTMX, so you can convert an existing website to a dynamic one without having to rewrite anything. Even better, you can configure it to merge into your current DOM, **and** it will preserve back button functionality. Adding it to my website was a breeze, and though for the user there may not be much of a difference, it has set me up to add more dynamic elements to my website in the future. I highly recommend checking it out.

## The Missing Piece: Typst

All of this was excellent, and my site was looking great. I had set up a dockerfile to build my backend and a docker compose file to deploy it along with Caddy as a reverse proxy. There was one piece missing however: I needed a way to create a single page PDF version of my resume, for easy distribution. I've previously used LaTeX for these sorts of purposes, but I quickly found that reading the data from my YAML file and creating templates with LaTeX was, well, messy and terrible. Not to mention, LaTeX is a huge dependency. I wanted something simpler. 

Back to googling, and I soon found [Typst](https://typst.app/). It's like LaTeX, but it's written in Rust. It uses its own language which is much simpler than LaTex and lets you do actual programming in the middle of your document. Plus, it has built in support for reading YAML files. Jackpot. I quickly got up and running and had a PDF version of my resume in no time. I cannot emphasize enough how simple that language was to learn compared to something like LaTeX. It took me about 2 hours to get a passable looking PDF version of my resume. Some tweaking over the next couple of days, and I have probably the best looking version of my resume that I've ever had. I love LaTeX (I was a math major after all), but for something non-technical, it was overkill. Typst was perfect.

## The Result and Next Steps

You can check out my site at [https://mikemehl.com](https://mikemehl.com), and the source is available at [my GitHub](https://github.com/mikemehl/mikemehl.com). I am extremely happy with the stack I landed on for my website. It's very simple, and adding additional content is a breeze. I've got two ideas for some next steps that I will probably implement in the coming weeks whenever I get bored with whatever other project I'm working on:

1. Currently, I'm using the CLI version of Typst to generate my resume PDF. I'd like to add a PDF generation endpoint to my backend, so that I can have a single binary that can generate my resume in HTML and PDF formats. Typst is written in rust and I believe has a library available, so this should be pretty breezy and make deployment even simpler.
2. I've got the raw power of HTMX just sitting there, and I am so tempted to use it. I think the first thing I'll add is this blog. ~~It should be possible to create a page where the main content is the HTML from this blog. Even better, with the right HTMX attributes, it should be possible to extract only the DOM elements I need and add them to the current page. Instant blog mirroring, and I only need to add some HTML attributes to my templates.~~ Well, that doesn't quite work. I'll have to do some more thinking on this one.

## Conclusion

Thanks for reading! I'm not a blogger, but I am very passionate about technology and love to share information. 
The key takeaway I have from this experience is that simplicity is underrated. I started out trying to do things in a more standard web development fashion, but because I took the time to observe those points of friction and pivot, I quickly landed on a simple solution that is a joy to work with. It can be difficult to do this at #dayjob, particularly when time constraints are tight, but taking that time to feel and acknowledge those points of friction is so important. In the end, it can greatly improve your developer experience as well as your end product. I hope this post has inspired you to do the same.

