---
title: Teams - Shots
---

# Shots

* TOC
{:toc}

## List shots for a team

    GET /teams/:team/shots

List shots by the team **and** team members.

### Response

<%= headers 200 %>
<%= json(:shot) { |hash| [hash.except(:team)] } %>
