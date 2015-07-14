var alboms, socket;

alboms = angular.module('alboms', []);

socket = io.connect(location.origin);

alboms.controller('page', function($scope, $http) {
  $http.get('/alboms/user').success(function(user) {
    $scope.user = user.user;
    $scope.alboms = user.albom
    $scope.add = "add albom"
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
    console.log("albom:", data)
    var rafff = {
      name:data
    }
    $http.get('alboms/close/albom', {params: rafff}).success(function (data) {
      $scope.alboms = data
    })
  }
  $scope.albo = function(data){
    $scope.allAlbom = $scope.alboms
    $scope.alboms = $scope.alboms.filter(function(el){
      console.log("data",data,"el",el.name)
      return data == el.name
    })
    console.log("name",$scope.alboms[0].name)
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
    console.log("picture:", data)
    picture = {
      name:data,
      albom:$scope.nameAlb
    }
    $http.get('alboms/close/picture',{params:picture}).success(function(data){
      $scope.alboms = data.filter(function(el){
        console.log("wl",el)
        return $scope.nameAlb == el.name
      })
      $scope.albom = $scope.alboms[0].picture
    })
  }
});

