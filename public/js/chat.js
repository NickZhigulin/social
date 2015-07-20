var chat, socket;

chat = angular.module('chat', []);

socket = io.connect(location.origin);

chat.controller('page', function($scope, $http) {
    $http.get('/home/user').success(function (user) {
        console.log(user)
        $scope.user = user.user;
        $scope.chatroom = user.chatroom
        socket.emit('subscribe', {_id: user.user.nickname});
        user.chatroom.forEach(function (el) {
            socket.emit('subscribe', {_id: el.id});
        })
        var count = 0
        $scope.chatroom.forEach(function (el) {
            console.log("el", el)
            id = {
                name: el.name
            }
            $http.get('/chat/rooms', {params: id}).success(function (history) {
                if (el.active) {
                    $scope.activechatroom=el;
                }
                $('.chatArea').scrollTop(90000)
                el.history = history
            })
        })
    });
    $scope.active = function (data) {
        console.log("data",data)
        $scope.chatroom.forEach(function (el) {
            if (el.name == data) {
                data = {
                    name: data
                }
                $http.get('/chat/activeChat', {params: data}).success(function (history) {
                    console.log($scope.activechatroom)
                    $scope.activechatroom = el
                })
            }
        })
        console.log($scope.activechatroom)
    }
    $scope.send = function (data) {
        message = {
            name:$scope.activechatroom.name,
            message:$scope.chatMessage
        }
        if ($scope.chatMessage) {
            $http.get('/chat/message', {params: message}).success(function (history) {
                $scope.activechatroom.history = history
                $scope.chatMessage = ""
                $('.chatArea').scrollTop(90000)
            })
        }
    }
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
    socket.on('chat', function (data) {
        console.log("send",data)
        $scope.activechatroom.history = data
        $scope.$apply()
        $('.chatArea').scrollTop(9000000)
    })
    $scope.exit = function(data) {
        $http.get('/home/exit').success(function (data) {
            location.assign('/')
        })
    }
})