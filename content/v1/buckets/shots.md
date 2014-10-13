---
title: Buckets - Shots
---

# Shots

* TOC
{:toc}

## List shots for a bucket

    GET /buckets/:id/shots

### Response

<%= headers 200 %>
<%= json(:shot) { |hash| [hash] } %>

## Add a shot to a bucket

    PUT /buckets/:id/shots

Adding a shot to a bucket requires the user to be authenticated with the `write`
scope. The authenticated user must also own the bucket.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| `shot_id` | `integer` | The ID of the shot to add. |

### Response

<%= headers 204 %>

## Remove a shot from a bucket

    DELETE /buckets/:id/shots

Removing a shot to a bucket requires the user to be authenticated with the
`write` scope. The authenticated user must also own the bucket.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| `shot_id` | `integer` | The ID of the shot to remove. |

### Response

<%= headers 204 %>
