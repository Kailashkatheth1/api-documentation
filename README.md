# developer.dribbble.com

This is a Dribbble API resource built with [nanoc](https://github.com/nanoc/nanoc).

## Development

[Foreman](https://github.com/ddollar/foreman) is used to start the nanoc compiler and server.

```sh
$ gem install foreman
$ foreman start
14:15:20 serve.1 | started with pid 38744
14:15:20 watch.1 | started with pid 38745
14:15:22 watch.1 | 14:16:22 - INFO - Guard is using TerminalTitle to send notifications.
14:15:22 watch.1 | 14:16:22 - INFO - Compilation succeeded.
14:15:32 watch.1 | 14:16:32 - INFO - Guard is now watching at 'api-documentation'
```

You can then view the site at [http://localhost:5000](http://localhost:5000).

## License

Except where otherwise noted, content is licensed under a [Creative Commons CC-BY license](http://creativecommons.org/licenses/by/3.0/us/).

The structure is based on the [GitHub Developer](https://github.com/github/developer.github.com) site. We thank GitHub for their code and their excellent tools for building software.
