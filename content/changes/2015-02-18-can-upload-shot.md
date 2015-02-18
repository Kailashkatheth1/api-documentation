---
kind: change
title: Determine if User Can Upload a Shot
author: tristandunn
created_at: 2015-02-18 10:00:00
---

User and team resources now include a `can_upload_shot` attribute that indicates
if they can currently upload shot or not. While we currently limit users to [24
shots per month and five per day][1] you can check this attribute without the
need to know the limits.

[1]: http://help.dribbble.com/customer/portal/articles/1039419
