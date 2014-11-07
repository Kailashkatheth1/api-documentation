---
kind: post
title: Throttle Record Creation in ActiveRecord
author: tristandunn
created_at: 2014-06-06 12:00:00
---

Throttling the creation of records is a component of our spam protection at
Dribbble. There's no sane reason for a user to create more than 10 comments in
two minutes, or more than 100 comments in one day. We've had a method for
setting these types of limits for a while, but we've extracted it into an
open-source library, [allowed][].

## Example Usage

```ruby
class Comment < ActiveRecord::Base
  belongs_to :screenshot
  belongs_to :user

  # Custom scopes beyond default created_at attribute.
  allow 10, per: 1.day, scope: :user_id
  allow 5,  per: 1.day, scope: [:screenshot_id, :user_id]

  # Custom error message.
  allow 100, per: 7.days, message: "Too many comments this week."

  # Custom conditions.
  allow 100, per: 7.days, unless: :whitelisted_user?
  allow 100, per: 7.days, unless: -> (comment) { comment.user.admin? }

  # Callbacks when limit is reached.
  allow 10, per: 2.minutes, callback: -> (comment) { comment.user.suspend! }
  allow 25, per: 5.minutes do |comment|
    comment.user.suspend!
  end

  def whitelisted_user?
    user.whitelisted? || screenshot.user == user
  end
end
```

## Future Development

Now that we've extracted it to make it a bit easier to work with, we'd like to
support different methods of checking throttles. For example, a week long check
would be better served using Redis over ActiveRecord. It helps to avoid extra
queries on save for a rare condition that may never be met and it's less
important to be perfectly accurate, so it doesn't matter if we lose the count.

[allowed]: https://github.com/dribbble/allowed
