var news, socket;

news = angular.module('news', []);

socket = io.connect(location.origin);

news.controller('page', function($scope, $http) {
  $http.get('/news/user').success(function (user) {
    $scope.user = user.user;
    $scope.friends = user.friends
    $scope.friends.push(user.user)
    $scope.history = user.history
    console.log("friends",user.history)
    $scope.friends.forEach(function (el) {
      var name = {
        name: el.name
      }
      $http.get('/news/news', {params: name}).success(function (history) {
        console.log("history", history.history[0])
        $scope.history.push(history.history[0])
      })
      //$scope.history = _sortBy($scope.history, function (el) {
      //  return el.id
      //})
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
})

