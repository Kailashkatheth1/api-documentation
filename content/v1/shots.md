---
title: Shots
---

# Shots

* TOC
{:toc}

## List shots

    GET /shots

### Parameters

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>list</code></td>
      <td><code>string</code></td>
      <td>
        Limit the results to a specific type with the following possible values:

        <ul>
          <li><code>animated</code></li>
          <li><code>attachments</code></li>
          <li><code>debuts</code></li>
          <li><code>playoffs</code></li>
          <li><code>rebounds</code></li>
          <li><code>teams</code></li>
        </ul>

        <strong>Default:</strong> Results of any type.
      </td>
    </tr>
    <tr>
      <td><code>timeframe</code></td>
      <td><code>string</code></td>
      <td>
        A period of time to limit the results to with the following possible values:

        <ul>
          <li><code>week</code></li>
          <li><code>month</code></li>
          <li><code>year</code></li>
          <li><code>ever</code></li>
        </ul>

        <strong>Default:</strong> Results from now.
      </td>
    </tr>
    <tr>
      <td><code>date</code></td>
      <td><code>date</code></td>
      <td>
        Limit the timeframe to a specific date, week, month, or year. Must be in the format of <code>YYYY-MM-DD</code>.
      </td>
    </tr>
    <tr>
      <td><code>sort</code></td>
      <td><code>string</code></td>
      <td>
        The sort field with the following possible values:

        <ul>
          <li><code>comments</code></li>
          <li><code>recent</code></li>
          <li><code>views</code></li>
        </ul>

        <strong>Default:</strong> Results are sorted by popularity.
      </td>
    </tr>
  </tbody>
</table>

### Response

<%= headers 200 %>
<%= json(:shot) { |hash| [hash] } %>

## Get a shot

    GET /shots/:id

#### Images

The `normal` image is typically 400x300, but may be smaller if created before
October 4th, 2012. The `width` and `height` provide the size of the `normal`
image.

The `hidpi` image may or may not be present, but will always be 800x600.

The `teaser` image is typically 200x150, but may be smaller if created before
October 4th, 2012.

### Response

<%= headers 200 %>
<%= json :shot %>

## Create a shot

    POST /shots

Creating a shot requires the user to be authenticated with the `upload` scope.
The authenticated user must also be a player or team.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| `title` | `string` | **Required.** The title of the shot. |
| `image` | `file` | **Required.** The image file.<br><br>It must be exactly 400x300 or 800x600, no larger than eight megabytes, and be a GIF, JPG, or PNG. |
| `description` | `string` | A description of the shot. |
| `tags` | `array` | Tags for the shot.<br><br>Limited to a maximum of 12 tags. |
| `team_id` | `integer` | An ID of a team to associate the shot with.<br><br>The authenticated user must either be a member of the team or be authenticated as the same team. |
| `rebound_source_id` | `integer` | An ID of a shot that the new shot is a rebound of.<br><br>The shot must be reboundable and by a user not blocking the authenticated user. |

### Response

Creating a shot happens asynchronously. After creation the returned location
will return a `404 Not Found` until processing is completed. If this takes
longer than five minutes, be sure to [contact
support](https://dribbble.com/contact?api).

<%= headers 202, Location: "https://api.dribbble.com/v1/shots/471756" %>

## Update a shot

    PUT /shots/:id

Updating a shot requires the user to be authenticated with the `upload` scope.
The authenticated user must also own the shot.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| `title` | `string` | The title of the shot. |
| `description` | `string` | A description of the shot. |
| `team_id` | `integer` | An ID of a team to associate the shot with.<br><br>The authenticated user must be on the team. If any empty value is provided the team association will be removed. |
| `tags` | `array` | Tags for the shot.<br><br>Limited to a maximum of 12 tags. If any existing tags are not provided they will be removed. |

### Example

<%= json title: SHOT[:title],
  description: SHOT[:description].gsub(/<[^>]+>/, ""),
  team_id: SHOT[:team][:id],
  tags: SHOT[:tags] %>

### Response

<%= headers 200 %>
<%= json(:shot) { |hash| hash.except(:user) } %>

## Delete a shot

    DELETE /shots/:id

Deleting a shot requires the user to be authenticated with the `upload` scope.
The authenticated user must also own the shot.
