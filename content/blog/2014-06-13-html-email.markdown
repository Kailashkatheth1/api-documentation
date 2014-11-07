---
kind: post
title: HTML Email
author: pbyrne
created_at: 2014-06-13 12:00:00
---

We recently added HTML versions of many of our email notifications. These new
emails are much nicer to look at and give us flexibility to provide more
information and context without overwhelming the message by using CSS to
emphasize the most important information. Response from our members has been
very positive, and we'll be continuing the rollout to the rest of our
notifications. However, the road to get from plain-text emails to HTML emails
was fraught with peril, so I want to share some of the lessons that we learned.

## It's HTML, I Know This

At first glance, adding HTML to your email seems pretty simple. Your website is
already HTML, you're really good at working with it, so how hard could it be?
As it happens, it's harder than you expect. For one thing, you have to forget
all of the lessons you've learned over the past decade about semantic markup
and new whizz-bang HTML5 and CSS3 features.

The simple fact is that HTML rendering across email clients is confusing and
inconsistent. The current best practices remind me quite a bit of web design in
the last 90's and early 2000's: tables nested inside tables. Don't believe me?
See what MailChimp [has to say][mc-tables] on the matter:

> If there’s only one thing you to know about coding email, it’s that tables
> rule the day.

MailChimp helpfully provides [some battle-tested templates][mc-blueprints] to
start with. [Dan Cederholm](https://dribbble.com/simplebits) started from
there, designed a Dribbble-branded base template, and designed several
different notifications using that template.  He built them as ERB templates
with static markup and handed them off to me to plug in the necessary Ruby to
populate them.

## The Tests Are Failing

Before even adding tests for the HTML portion of the emails, our tests on the
plain-text versions began to fail. Our tests for the emails look something like
this:

```ruby
mail = Notifier.comment_notification(comment)
assert_match user_url(comment.user), mail.body.to_s
```

Up until this point, `mail.body.to_s` would return the text of the email. Once
you add a second ActionMailer template, that stops being true. Hopping into a
console, I discovered that `mail.body.to_s` was now an empty string. What? Some
more poking around led me to `mail.body.parts` which was an array of the
plain-text email and the HTML email template, and `mail.text_part` and
`mail.html_part` which would give me exactly the portion of the email I wanted
to test.

Emboldened by my newfound knowledge, I built a new test helper:

```ruby
def assert_text(mail, value)
  assert_match value, mail.text_part.body.to_s
end

# now the test looks like this
mail = Notifier.comment_notification(comment)
assert_text mail, user_url(comment.user)
```

Strangely, this test helper, which worked for emails with both plain-text and
HTML templates, failed for our emails with just plain text. For those emails,
`mail.text_part` was nil. Again, what? This necessitated building a
more-complex method to fetch the text that I wanted to test:

```ruby
def assert_text(mail, value)
  assert_match value, extract_content_of_type(mail, :text)
end

def extract_content_of_type(mail, type)
  if mail.parts.any?
    # with multiple parts, grab the one of the given type
    matching_part = mail.public_send("#{type}_part")
    assert matching_part, "Must have a part with type '#{type}'"
    matching_part.body.to_s
  else
    # if just one part of the email, assume it's what we want
    mail.body.to_s
  end
end
```

With this done, tests on our plain-text emails were passing again.

## Testing the Markup

Now I wanted to add similar tests to the HTML emails. Since they're HTML, I
also wanted to use the same Rails-provided assertions we had used for our
views, such as `assert_select`. Rails doesn't provide that out of the box, but
some searching lead me to [this blog post][html-email-test], which gave me
exactly what I wanted. I tweaked their approach slightly and ended up with
this:

```ruby
def assert_html(mail, &block)
  root = HTML::Document.new(extract_content_of_type(mail, :html)).root
  assert_select root, ":root", &block
end

# and the test looks like this
mail = Notifier.comment_notification(comment)
assert_html(mail) do
  assert_select "a[href=?]", user_url(comment.user)
end
```

Now I can get started with some tests and filling in the static HTML mockup
with Ruby to make them dynamic.

## And Now For Tests of a Different Color

Of course, that's just half of the testing story. Remember what I said before
about inconsistent rendering between email clients? We want these shiny new
emails to look good for everybody, but testing against so many clients is hard.
Thankfully, tools like [Litmus][] make things easier.

Send Litmus your HTML (or forward them an email) and they'll run it through a
battery of clients and provide you screenshots of how your emails render.
Lather, rinse, and repeat until you're happy with the results. I can't stress
enough how important this was, as we found a number of bugs in our email
template and strange rendering in common clients that we were able to correct
before any of our members saw them.

## You Didn't Actually Want CSS in There, Did You?

As we were about to ship, we ran into a showstopper: Gmail ignores any linked
stylesheets or `style` elements in your email. The best practice for styling
HTML in an email is to use inline style attributes (for example `<p style="color:
font-size: 16px; font-weight: bold">…</p>`).

Unwilling to perform this madness, we went out in search for a tool which would
automatically convert our external stylesheets to inline attributes, and found
[actionmailer_inline_css][]. It hooks into the ActionMailer lifecycle and runs
the emails through [premailer][] to parse the CSS and add inline styles when
delivering. This saved us from having to muck up our code with inline styles
and allowed us to still share CSS between our emails.

## There You Have It

It took a bit more work than we anticipated, but we've been happy with the
result and the reaction from our members has been positive. Now that we've laid
the groundwork, rolling out HTML versions for the rest of our notifications
will hopefully be easier.

[mc-tables]:http://templates.mailchimp.com/development/html/
[mc-blueprints]:https://github.com/mailchimp/Email-Blueprints
[html-email-test]:http://pathfindersoftware.com/2010/04/rails-email-unit-testing/
[litmus]:https://litmus.com/
[actionmailer_inline_css]:https://github.com/premailer/actionmailer_inline_css
[premailer]:https://github.com/premailer/premailer/
