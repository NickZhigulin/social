var home, socket;

home = angular.module('home', []);

socket = io.connect(location.origin);

home.controller('home', function($scope, $http) {
  $http.get('/home/user').success(function(user) {
    $scope.user = user.user;
    $scope.history = user.history.reverse();
    $scope.chatroom = user.chatrooms
    $scope.add ='hidd'
    //$scope.news = user.news;
    socket.emit('subscribe', {_id: $scope.user.nickname});
  });
  $scope.sendNews = function() {
    var send = {
      mess:$scope.mess
    };
    $http.get('home/history', {params:send}).success(function(data) {
      $scope.history = data.reverse();
      $scope.add ="hidd";
      $scope.mess = " "
    })
  };
  $scope.close = function(data) {
    var close;
    close = $scope.history.filter(function (el) {
      return el.id == data
    });
    close = {
      id: close[0].id
    };
    $http.post('home/close', close).success(function (data) {
      console.log("data", data);
      $scope.history = data.reverse();
    })
  };
  $scope._search = function(data) {
    search = {
      name:$scope.search
    };
    $http.get('/home/search',{params:search}).success(function(data){
      console.log("data", data)
      $scope.search="";
      $scope.find = data
    })
  };
  $scope.cancel = function(data){
    $scope.clickavatar = ""
  }
  socket.on('avatar', function (avatar) {
    console.log("send",data)
    $scope.user.avatar = avatar
    $scope.$apply()
  })
  $scope.exit = function(data){
    $http.post('/home/exit').success(function(data){
      location.assign('/')
    })
  }
  $.getJSON('', function(data){
      console.log("data",data.ip)
  });
});


home.controller('friend', function($scope, $http) {
  $http.get('/friends/user').success(function(user) {
    $scope.user = user.user;
    $scope.friends = user.friends
    console.log("friends",$scope.friends)
  });
  $scope._search = function(data) {
    search = {
      name:$scope.search
    };
    $http.get('home/search',{params:search}).success(function(data){
      console.log($scope.find)
      $scope.search="";
      $scope.find = data
      console.log(data)
    })
  };
  $scope.sendmess = function(data) {
    var name ={
      name:data
    }
    $http.get('/user/'+data+'/chat').success(function (el){
      location.assign('/chat')
    })
  }
  $scope.exit = function(data) {
    $http.get('/home/exit').success(function (data) {
      location.assign('/')
    })
  }
});

home.controller('chat', function($scope, $http) {
  $http.get('/home/user').success(function (user) {
    console.log(user)
    $scope.user = user.user;
    $scope.chatroom = user.chatroom
    socket.emit('subscribe', {_id: user.user.nickname});
    user.chatroom.forEach(function (el) {
      socket.emit('subscribe', {_id: el.id});
    })
    var count = 0
    $scope.chatroom.forEach(function (el) {
      console.log("el", el)
      id = {
        name: el.name
      }
      $http.get('/chat/rooms', {params: id}).success(function (history) {
        if (el.active) {
          $scope.activechatroom=el;
        }
        $('.chatArea').scrollTop(90000)
        el.history = history
      })
    })
  });
  $scope.active = function (data) {
    console.log("data",data)
    $scope.chatroom.forEach(function (el) {
      if (el.name == data) {
        data = {
          name: data
        }
        $http.get('/chat/activeChat', {params: data}).success(function (history) {
          console.log($scope.activechatroom)
          $scope.activechatroom = el
        })
      }
    })
    console.log($scope.activechatroom)
  }
  $scope.send = function (data) {
    message = {
      name:$scope.activechatroom.name,
      message:$scope.chatMessage
    }
    if ($scope.chatMessage) {
      $http.post('/chat/message', message).success(function (history) {
        $scope.activechatroom.history = history.reverse()
        $scope.chatMessage = ""
      })
    }
  }
  $scope._search = function(data) {
    search = {
      name:$scope.search
    };
    $http.get('home/search',{params:search}).success(function(data){
      console.log($scope.find)
      $scope.search="";
      $scope.find = data
      console.log(data)
    })
  };
  socket.on('chat', function (data) {
    console.log("send",data)
    $scope.activechatroom.history = data
    $scope.$apply()
    $('.chatArea').scrollTop(9000000)
  })
  $scope.exit = function(data) {
    $http.get('/home/exit').success(function (data) {
      location.assign('/')
    })
  }
})

home.controller('alboms', function($scope, $http) {
  $http.get('/alboms/user').success(function(user) {
    $scope.user = user.user;
    $scope.alboms = user.albom
    $scope.add = "add albom"
  });
  $scope._search = function(data) {
    search = {
      name:$scope.search
    };
    $http.get('/home/search',{params:search}).success(function(data){
      $scope.search="";
      $scope.find = data
    })
  };
  $scope._add = function(data) {
    if ($scope.add == "add albom") {
      $scope.addWind = 'vis'
    }
    if ($scope.add == "add picture") {
      $scope.uploadWind = 'vis'
    }
  }
  $scope.addAlbom = function(data){
    albom = {
      name: $scope.nameAlbom
    }
    $http.get('/alboms/newAlbom', {params: albom}).success(function (data) {
      $scope.alboms = data
      $scope.nameAlbom = " "
      $scope.addWind = "hidd"
    })
  }
  $scope.closeAlbom = function(data){
    var rafff = {
      name:data
    }
    $http.post('/alboms/close/albom',rafff).success(function (data) {
      $scope.alboms = data
    })
  }
  $scope.albo = function(data){
    $scope.allAlbom = $scope.alboms
    $scope.alboms = $scope.alboms.filter(function(el){
      return data == el.name
    })
    $scope.activeAlbom = "/alboms/upload/"+$scope.alboms[0].name
    $scope.nameAlb = $scope.alboms[0].name
    $scope.albom = $scope.alboms[0].picture
    $scope.add = "add picture"
    $scope.vissAlboms='none'
    $scope.vissAlbom='unnone'
  }
  $scope.up = function(data){
    $scope.add = "add albom"
    $scope.alboms = $scope.allAlbom
    $scope.vissAlboms='unnone'
    $scope.vissAlbom='none'
  }
  $scope.closePicture = function(data){
    picture = {
      name:data,
      albom:$scope.nameAlb
    }
    $http.post('/alboms/close/picture',picture).success(function(data){
      $scope.alboms = data.filter(function(el){
        return $scope.nameAlb == el.name
      });
      $scope.albom = $scope.alboms[0].picture
    })
  }
  $scope.cancel=function(data){
    $scope.uploadWind = 'hidd'
  }
  $scope.fullSize = function(data){
    $scope.full = data
    $scope.size = "unnone"
  }
  $scope.closeFullPicture = function(data) {
    $scope.size = "none"
  }
  $scope.exit = function(data) {
    $http.post('/home/exit').success(function (data) {
      location.assign('/')
    })
  }
});

home.controller('news', function($scope, $http) {
  $http.get('/news/user').success(function (user) {
    $scope.user = user.user;
    $scope.friends = user.friends
    $scope.history = user.history
    console.log("friends",user.history)
    $scope.friends.forEach(function (el) {
      var name = {
        name: el.name
      }
      $http.get('/news/news', {params: name}).success(function (history) {
        $scope.history.push(history.history[0])
        $scope.history = _.sortBy($scope.history, function (el) {
          console.log("el", el)
          return el.id
        })
      })
      console.log("$scope.history",$scope.history)
    })
    $scope._search = function (data) {
      search = {
        name: $scope.search
      };
      $http.get('home/search', {params: search}).success(function (data) {
        console.log($scope.find)
        $scope.search = "";
        $scope.find = data
      })
    }
  })
  $scope.exit = function(data) {
    $http.post('/home/exit').success(function (data) {
      location.assign('/')
    })
  }
})