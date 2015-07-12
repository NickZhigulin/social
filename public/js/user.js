var user, socket;

user = angular.module('user', []);

socket = io.connect(location.origin);

user.controller('page', function($scope, $http, $location) {
    $http.get(location.pathname+'/data').success(function (data) {
        console.log("data",data)
        $scope.user = data.user;
        $scope.history = data.history;
        $scope.friend = data.friend;
    })
    $scope._friend = function(data) {
        if ($scope.friend == "Add friend") {
            $http.get(location.pathname + '/friend').success(function (data) {
                $scope.friend = data.friend
            })
        }
        if ($scope.friend == "Delete friend") {
            $http.get(location.pathname + '/delete').success(function (data) {
                $scope.friend = data.friend
            })
        }
    }
    $scope.sendmess = function(data) {
        $http.get(location.pathname + '/chat').success(function (data){
            location.assign('/chat')
        })
    }
})