---
title: Projects - Shots
---

# Shots

* TOC
{:toc}

## List shots for a project

    GET /projects/:id/shots

### Response

<%= headers 200 %>
<%= json(:shot) { |hash| [hash] } %>
