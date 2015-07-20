var news, socket;

news = angular.module('news', []);

socket = io.connect(location.origin);

news.controller('page', function($scope, $http) {
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
    $http.get('/home/exit').success(function (data) {
      location.assign('/')
    })
  }
})

