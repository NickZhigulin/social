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
                id: el.id
            }
            $http.get('/chat/rooms', {params: id}).success(function (history) {
                if (!count) {
                    $scope.activechatroom=el;
                    count++
                }
                $('.chatArea').scrollTop(9000000)
                el.history = history
            })
        })
    });
    $scope.active = function (data) {
        $scope.chatroom.forEach(function (el) {
            if (el.name == data) {
                $scope.activechatroom = el
            }
        })

        console.log("active",$scope.activechatroom)
    }
    $scope.send = function (data) {
        message = {
            id:$scope.activechatroom.id,
            message:$scope.chatMessage
        }
        if ($scope.chatMessage) {
            $http.get('/chat/message', {params: message}).success(function (history) {
                $scope.activechatroom.history = history
                $scope.chatMessage = ""
                $('.chatArea').scrollTop(9000000)
            })
        }
    }
    socket.on('chat', function (data) {
        console.log("send",data)
        $scope.activechatroom.history = data
        $scope.$apply()
    })
})