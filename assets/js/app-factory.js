var app = angular.module('colloquiumApp', ['ngResource'])
app.factory('Article', ['$resource', function($resource) {
    return $resource('/api/articles/:articleId', null,
            {
                'query': {method:'GET', isArray:true},
                'update': { method:'PUT' }
            });
}]);
