---
title: Shots - Comments
---

# Comments

* TOC
{:toc}

## List comments for a shot

    GET /shots/:shot/comments

### Response

<%= headers 200 %>
<%= json(:comment) { |hash| [hash] } %>

## List likes for a comment

    GET /shots/:shot/comments/:id/likes

### Response

<%= headers 200 %>
<%= json(:like_with_user) { |hash| [hash] } %>

## Create a comment

    POST /shots/:shot/comments

Creating a comment requires the user to be authenticated with the `comment`
scope. The authenticated user must also be a player or team.

Any username mentions, such as @simplebits, are automatically parsed and linked.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| `body` | `string` | **Required.** The contents of the comment. |

### Example

<%= json body: COMMENT[:body] %>

### Response

<%= headers 201, Location: "https://api.dribbble.com/v1/shots/471756/comments/3360155" %>
<%= json(:comment) %>

## Get a single comment

    GET /shots/:shot/comments/:id

### Response

<%= headers 200 %>
<%= json(:comment) %>

## Update a comment

    PUT /shots/:shot/comments/:id

Updating a comment requires the user to be authenticated with the `comment`
scope. The authenticated user must also own the comment.

### Response

<%= headers 200 %>
<%= json(:comment) %>

## Delete a comment

    DELETE /shots/:shot/comments/:id

Deleting a comment requires the user to be authenticated with the `comment`
scope. The authenticated user must also own the comment.

### Response

<%= headers 204 %>

## Check if you like a comment

    GET /shots/:shot/comments/:id/like

Checking for a comment like requires the user to be authenticated.

### Response, if the user likes the comment

<%= headers 200 %>
<%= json :like %>

### Response, if the user does not like the comment

<%= headers 404 %>

## Like a comment

    POST /shots/:shot/comments/:id/like

Liking a comment requires the user to be authenticated with the `write` scope.

### Response

<%= headers 201 %>
<%= json :like %>

## Unlike a comment

    DELETE /shots/:shot/comments/:id/like

Unliking a comment requires the user to be authenticated with the `write` scope.

### Response

<%= headers 204 %>
