var home, socket;

home = angular.module('home', []);

socket = io.connect(location.origin);

home.controller('page', function($scope, $http) {
  $http.get('/home/user').success(function(user) {
    $scope.user = user.user;
    $scope.history = user.history;
    $scope.chatroom = user.chatrooms
    //$scope.news = user.news;
    socket.emit('subscribe', {_id: $scope.user._id});
    socket.emit('subscribe', {_id: $scope.user.nickname});
  });
  $scope.sendNews = function() {
    var send = {mess:$scope.mess};
    $http.get('home/history',{params:send}).success(function(data){
      $scope.history = data;
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
    $http.get('home/search',{params:search}).success(function(data){
      console.log($scope.find)
      $scope.search="";
      $scope.find = data
      console.log(data)
    })
  };

//arr = _.sortBy(arr,function(el){
//  return el.id
});

