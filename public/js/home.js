var home, socket;

home = angular.module('home', []);

socket = io.connect(location.origin);

home.controller('page', function($scope, $http) {
  $http.get('/home/user').success(function(user) {
    $scope.user = user.user;
    $scope.history = user.history.reverse();
    $scope.chatroom = user.chatrooms
    //$scope.news = user.news;
    socket.emit('subscribe', {_id: $scope.user.nickname});
  });
  $scope.sendNews = function() {
    var send = {
      mess:$scope.mess
    };
    $http.get('home/history',{params:send}).success(function(data){
      $scope.history = data.reverse();
      $scope.add ="hidd";
      $scope.mess = " "
    })
  };
  $scope.close = function(data) {
    var close;
    close = $scope.history.filter(function(el){
      return el.id == data
    });
    close= {
      id:close[0].id
    };
    $http.get('home/close',{params:close}).success(function(data){
      console.log("data",data);
      $scope.history = data
    })
  };
  $scope._search = function(data) {
    search = {
      name:$scope.search
    };
    $http.get('/home/search',{params:search}).success(function(data){
      console.log($scope.find)
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
    $http.get('/home/exit').success(function(data){
      location.assign('/')
    })
  }
});

