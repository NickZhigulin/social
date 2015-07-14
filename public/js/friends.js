var friends, socket;

friends = angular.module('friends', []);

socket = io.connect(location.origin);

friends.controller('page', function($scope, $http) {
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
    $http.get( '/chat').success(function (data){
      location.assign('/chat')
    })
  }
});

