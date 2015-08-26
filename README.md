# Metrics

**Metrics** is a tool for tracking arbitrary metrics via [Slack](https://slack.com).

At [Collective Idea](http://collectiveidea.com), we love data! We also use Slack
for a lot of our day-to-day communications. The Metrics app allows us to track
all sorts of data without leaving our normal workflow.

[![Build Status](https://travis-ci.org/collectiveidea/metrics.svg?branch=master)](https://travis-ci.org/collectiveidea/metrics)
[![Code Climate](https://codeclimate.com/github/collectiveidea/metrics/badges/gpa.svg)](https://codeclimate.com/github/collectiveidea/metrics/code)
[![Test Coverage](https://codeclimate.com/github/collectiveidea/metrics/badges/coverage.svg)](https://codeclimate.com/github/collectiveidea/metrics/coverage)
[![Dependency Status](https://gemnasium.com/collectiveidea/metrics.svg)](https://gemnasium.com/collectiveidea/metrics)

## How does it work?

We use Slack's [Slash Commands](https://api.slack.com/slash-commands) to listen
to our team for `/track` commands. When one is found, it's sent to the Metrics
app to be parsed. The app stores several metrics with regular expression
patterns that may or may not match the incoming command.

If a matching metric is found, the command text is parsed, capturing data from
all [named groups](http://www.regular-expressions.info/named.html) as metadata.
A data point is created for that metric, for that user, with that metadata.

The data point stores its metadata in [hstore](http://www.postgresql.org/docs/9.0/static/hstore.html).
The combination of regular expressions and hstore provide endless possibilities
for arbitrary data capture.

The optional `user` and `number` named groups are special. The `user` group is
used for attribution of the data point to a particular Slack user (defaults to
the slash command sender). The `number` group is used to quantify the data point
and is stored as a decimal number (defaults to 1.0).

## Local Setup

```
$ git clone git@github.com:collectiveidea/metrics.git
$ cd metrics
$ rvm 2.2.2@metrics --create --ruby-version
$ bin/setup
$ rspec
```
