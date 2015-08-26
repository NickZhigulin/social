RedisSessions = require("redis-sessions");
rs = new RedisSessions();

rsapp = "myapp";

rs.create {
    app: rsapp
    id: 'user1001'
    ip: '192.168.22.58'
    ttl: 3600
    d:
      foo: 'bar'
      unread_msgs: 34
  }, (err, resp) ->
    console.log "resp:", resp, "err:", err