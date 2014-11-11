---
title: Teams - Members
---

# Members

* TOC
{:toc}

## List a team's members

    GET /teams/:team/members

### Response

<%= headers 200 %>
<%= json(:user) { |hash| [hash] } %>
