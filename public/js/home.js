var home, socket;

home = angular.module('home', []);

socket = io.connect(location.origin);

home.controller('page', function($scope, $http) {
  $http.get('/home/user').success(function(user) {
    $scope.user = user;
  });
  $scope.sendNews = function() {
    send = {news:$scope.mess}
    $http.get('home/news',{params:send}).success(function(data){
      console.log("data",data)
      $scope.add ="hidd"
    })
  }
});

