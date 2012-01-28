exports.routes = function (map) {
    map.resources('fonts');



    // Generic routes. Add all your routes below this line
    // feel free to remove generic routes
    //map.all(':controller/:action');
    //map.all(':controller/:action/:id');
    map.namespace('admin', function (admin) {
	    admin.resources('fonts');
	});

    map.get('/', 'landing#index');
};