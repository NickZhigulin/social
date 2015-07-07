var home, socket;

home = angular.module('home', []);

socket = io.connect(location.origin);

home.controller('page', function($scope, $http) {
  $http.get('/home/user').success(function(user) {
    $scope.user = user;
    $scope.history = user.history
    $scope.news = user.news
    socket.emit('subscribe', {_id: $scope.user._id});
    socket.emit('subscribe', {_id: $scope.user.nickname});
  });

  $scope.sendNews = function() {
    var send = {mess:$scope.mess}
    $http.get('home/history',{params:send}).success(function(data){
      $scope.history = data
      $scope.add ="hidd"
      $scope.mess = " "
    })
  }
  $scope.close = function(data) {
    var close
    close = $scope.news.filter(function(el){
      return el.id == data
    })
    close= {
      id:close[0].id
    }
    $http.get('home/close',{params:close}).success(function(data){
      console.log("data",data)
      $scope.history = data
    })
  }

});

var arr = [{id:4},{id:2},{id:4},{id:5},{id:1},{id:8},{id:7},{id:43},{id:24},{id:14},{id:45},]
arr = _.sortBy(arr,function(el){
  console.log("el",el)
  return el.id
})
console.log("arr",arr)
