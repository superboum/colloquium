app.controller('HomeCtrl', function($scope, $resource, Article) {
    $scope.articles = Article.query(function() {
        console.log('hey');
    });
});
