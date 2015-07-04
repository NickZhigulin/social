var home, socket;

home = angular.module('home', []);

socket = io.connect(location.origin);

home.controller('page', function($scope, $http) {
  $http.get('/home/user').success(function(user) {
    $scope.user = user;
    $scope.news = user.history
    socket.emit('subscribe', {_id: $scope.user._id});
    socket.emit('subscribe', {_id: $scope.user.nickname});
  });

  $scope.sendNews = function() {
    send = {news:$scope.mess}
    $http.get('home/news',{params:send}).success(function(data){
      $scope.news = data
      $scope.add ="hidd"
      $scope.mess = " "
    })
  }

});

