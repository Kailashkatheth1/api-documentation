---
title: Shots - Attachments
---

# Attachments

* TOC
{:toc}

## List attachments for a shot

    GET /shots/:id/attachments

### Response

<%= headers 200 %>
<%= json(:attachment) { |hash| [hash] } %>

## Create an attachment

    POST /shots/:shot/attachments

Creating an attachment requires the user to be authenticated with the `upload`
scope. The authenticated user must own the shot and be a pro, a team, or a
member of a team.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| `file` | `file` | **Required.** The attachment file.<br><br>It must be no larger than 10 megabytes. |

### Response

Creating an attachment happens asynchronously. After creation the returned
location will return a `404 Not Found` until processing is completed. If this
takes longer than five minutes, be sure to [contact
support](https://dribbble.com/contact?api).

<%= headers 202, Location: "https://api.dribbble.com/v1/shots/471756/attachments/73829" %>

## Get a single attachment

    GET /shots/:shot/attachments/:id

A `thumbnail_url` is only present for image attachments.

### Response

<%= headers 200 %>
<%= json :attachment %>

## Delete an attachment

    DELETE /shots/:shot/attachments/:id

Deleting an attachment requires the user to be authenticated with the `upload`
scope. The authenticated user must also own the attachment.

### Response

<%= headers 204 %>
