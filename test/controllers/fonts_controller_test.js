require('../test_helper.js').controller('fonts', module.exports);

var sinon  = require('sinon');

function ValidAttributes () {
    return {
        
    };
}

exports['fonts controller'] = {

    'GET new': function (test) {
        test.get('/fonts/new', function () {
            test.success();
            test.render('new');
            test.render('form.' + app.set('view engine'));
            test.done();
        });
    },

    'GET index': function (test) {
        test.get('/fonts', function () {
            test.success();
            test.render('index');
            test.done();
        });
    },

    'GET edit': function (test) {
        var find = Fonts.find;
        Fonts.find = sinon.spy(function (id, callback) {
            callback(null, new Fonts);
        });
        test.get('/fonts/42/edit', function () {
            test.ok(Fonts.find.calledWith('42'));
            Fonts.find = find;
            test.success();
            test.render('edit');
            test.done();
        });
    },

    'GET show': function (test) {
        var find = Fonts.find;
        Fonts.find = sinon.spy(function (id, callback) {
            callback(null, new Fonts);
        });
        test.get('/fonts/42', function (req, res) {
            test.ok(Fonts.find.calledWith('42'));
            Fonts.find = find;
            test.success();
            test.render('show');
            test.done();
        });
    },

    'POST create': function (test) {
        var fonts = new ValidAttributes;
        var create = Fonts.create;
        Fonts.create = sinon.spy(function (data, callback) {
            test.strictEqual(data, fonts);
            callback(null, fonts);
        });
        test.post('/fonts', {Fonts: fonts}, function () {
            test.redirect('/fonts');
            test.flash('info');
            test.done();
        });
    },

    'POST create fail': function (test) {
        var fonts = new ValidAttributes;
        var create = Fonts.create;
        Fonts.create = sinon.spy(function (data, callback) {
            test.strictEqual(data, fonts);
            callback(new Error, null);
        });
        test.post('/fonts', {Fonts: fonts}, function () {
            test.success();
            test.render('new');
            test.flash('error');
            test.done();
        });
    },

    'PUT update': function (test) {
        Fonts.find = sinon.spy(function (id, callback) {
            test.equal(id, 1);
            callback(null, {id: 1, updateAttributes: function (data, cb) { cb(null); }});
        });
        test.put('/fonts/1', new ValidAttributes, function () {
            test.redirect('/fonts/1');
            test.flash('info');
            test.done();
        });
    },

    'PUT update fail': function (test) {
        Fonts.find = sinon.spy(function (id, callback) {
            test.equal(id, 1);
            callback(null, {id: 1, updateAttributes: function (data, cb) { cb(new Error); }});
        });
        test.put('/fonts/1', new ValidAttributes, function () {
            test.success();
            test.render('edit');
            test.flash('error');
            test.done();
        });
    },

    'DELETE destroy': function (test) {
        test.done();
    },

    'DELETE destroy fail': function (test) {
        test.done();
    }
};

