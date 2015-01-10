angular.module "meanCMS", [
  "ngResource"
  "ngRoute"
  "ngSanitize"
]

.config [ "$locationProvider", "$httpProvider", "$routeProvider", ($locationProvider, $httpProvider, $routeProvider) ->
  $locationProvider.html5Mode true
  $httpProvider.interceptors.push "authInterceptor"

  $routeProvider

  .when "/users/new",
    templateUrl: "/views/users/new"
    controller: "User.new"

  .when "/users",
    templateUrl: "/views/users/index"
    controller: "User.index"

  .when "/sessions/new",
    templateUrl: "/views/sessions/new"
    controller: "Session.new"

  .when "/pages/new",
    templateUrl: "/views/pages/new"
    controller: "Page.new"

  .when "/pages",
    templateUrl: "/views/pages/index"
    controller: "Page.index"

  .when "/pages/:page_id/edit",
    templateUrl: "/views/pages/edit"
    controller: "Page.edit"

]

.factory "User", [ "$resource",
  ($resource) -> $resource "/api/users/:id", { id: "@id" }, { update: { method:"PUT" }}
]

.factory "Session", [ "$resource", "$window", "$location", ($resource, $window, $location) ->
  Session = $resource "/api/sessions"
  Session
]

.factory "Page", [ "$resource",
  ($resource) -> $resource "/api/pages/:id", { id: "@id" }, { update: { method:"PUT" }}
]

.factory "authInterceptor", [ "$q", "$window", "$location", ($q, $window, $location) ->
    request: (config) ->
      config.headers = config.headers || {}
      if $window.localStorage.token
        config.headers.Authorization = "Bearer " + $window.localStorage.token
      config

    response: (response) ->
      response || $q.when(response)

    responseError: (rejection) ->
      if rejection.status is 401
        delete $window.localStorage.token
        $location.path "/sessions/new"
      $q.reject rejection
]

.filter 'unsafe', [ '$sce', ($sce) ->
  $sce.trustAsHtml
]

.controller "User.new", [ "$scope", "$location", "$window", "User", ($scope, $location, $window, User) ->
  $scope.save = (user) ->
    User.save(user,
      (res) ->
        $window.sessionStorage.token = res.token
        console.log "success"
      (err) ->
        console.log err
    )
]

.controller "User.index", [ "$scope", "$location", "$window", "User", ($scope, $location, $window, User) ->
  $scope.users = User.query()
]

.controller "Session.new", [ "$scope", "$location", "$window", "Session", ($scope, $location, $window, Session) ->
  $scope.save = (user) ->
    Session.save(user,
      (res) ->
        $window.localStorage.token = res.token
        $location.path "/users"
      (err) ->
        console.log err
    )
]

.controller "Page.new", [ "$scope", "$location", "$window", "Page", ($scope, $location, $window, Page) ->
  $scope.save = (page) ->
    Page.save(page,
      (res) ->
        console.log "success"
      (err) ->
        console.log err
    )
]

.controller "Page.edit", [ "$scope", "$routeParams", "$window", "Page", ($scope, $routeParams, $window, Page) ->

  Page.get(
    id: $routeParams.page_id
    (page) ->
      $scope.page = page
  )

  $scope.save = (page) ->
    Page.update(id: page._id, page,
      (res) ->
        $scope.pageForm.$setPristine()
      (err) ->
        console.log err
    )
]

.controller "Page.index", [ "$scope", "$location", "$window", "Page", ($scope, $location, $window, Page) ->
  $scope.pages = Page.query()
]
