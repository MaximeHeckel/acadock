_ = require "underscore"
endpoint = require "../endpoints"
request = require "request"

class Container
  @find: (name, cb) ->
    request.get
      url: endpoint.getUrl "inspect", "docker", name
      (err, response, body) ->
        if response.statusCode != 200
          cb null, body
        else
          docker_container = JSON.parse(body)
          cb docker_container, null

  @findAll: (cb) ->
    request.get
      url: endpoint.getUrl "list", "docker"
      (err, response, body) ->
        if response.statusCode != 200
          cb null, body
        else
          docker_containers = JSON.parse(body)
          cb(docker_containers, null)

  @create: (params, cb) ->
    request.post
      url: endpoint.getUrl "create", "docker"
      json:
        "Hostname": params.hostname || ""
        "User": params.user || ""
        "Memory": 0
        "MemorySwap": 0
        "AttachStdin": false
        "AttachStdout": false
        "AttachStderr": false
        "PortSpecs": null
        "Tty": false
        "OpenStdin": false
        "StdinOnce": false
        "Env": null
        "Cmd": [params.command]
        "Dns": null
        "Image": "base"
        "Volumes": {}
        "VolumesFrom": ""
      (err, response, body) ->
        if err || response.statusCode != 201
          console.log response.statusCode + " : " + util.inspect(body, false, null)
          cb(null, err)
        else
          cb(body, null)


module.exports = Container
