_ = require "underscore"
Docker = require "../docker"
request = require "request"


class Container
  constructor: (id, image, status, created, user, hostname, command) ->
    @id = id
    @image = image
    @status = status
    @created = new Date parseInt(created)
    @user = user
    @hostname = hostname
    @command = command

  @findAll: (cb) ->
    request.get Docker.getUrl("list"),
      (err, response, body) ->
        if response.statusCode != 200
          cb(null, err)
        else
          docker_containers = JSON.parse(body)
          containers = _.map docker_containers, (container) ->
            new Container container.Id, container.Image, container.Status, container.Created
          cb(containers, null)
  @create: (cb) ->
    request.post Docker.getUrl("create"),
      (err, response, body) ->
        if response.statusCode != 200
          cb(null, err)
        else
          docker_containers = JSON.parse(body)
          containers = _.map docker_containers, (container) ->
          new Container container.Hostname, container.Command
          cb(containers,null)

module.exports = Container
