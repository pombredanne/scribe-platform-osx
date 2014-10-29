// TODO:
// This should have been written in Jasmine, so that I can
// reuse them across projects without having to re-port the
// test harness.

function buildWindow(opts) {
  var defaults = {
    center: true,
    width: 800,
    height: 900,
    top: 2,
    left: 1,
    chrome: false
  };
  opts = opts || {};
  for (var key in opts) {
    defaults[key] = opts[key];
  }
  return Scribe.Window.create(defaults);
}

function spy(retVal) {
  var called = 0;
  var me = function() { called++; return retVal }
  me.called = function() { return called; };
  return me;
}

function sleep(s) {
  var t = (new Date()).getTime()+1000*s; while((new Date()).getTime() < t);
}

UnitTest("after calling on('x'), trigger('x') fires the callback", function(){
  var win = buildWindow();
  var agent = spy();
  win.on('x', agent);
  win.trigger('x');
  Assert(agent.called());
});

UnitTest("after calling on('x'), trigger('y') does not fire the callback", function(){
  var win = buildWindow();
  var agent = spy();
  win.on('x', agent);
  win.trigger('y');
  AssertFalse(agent.called());
});

// TODO: NEED ASYNCHRONOUS SPEC HANDLING!

// UnitTest("the 'close' event is fired on close", function(cb) {
//   var win = buildWindow();
//   win.on('close', function() { cb(); });
//   win.close();
// });

// UnitTest("the 'move' event is fired on move", function(cb){
//   var win = buildWindow();
//   win.on('move', function() { cb(); });
//   win.left = 300;
//   win.close();
// });

// UnitTest("the 'resize' event is fired on resize", function(cb){
//   var win = buildWindow();
//   win.on('resize', function() { cb(); });
//   win.height = 300;
//   win.close();
// });

// UnitTest("the 'minimize' event is fired on minimize", function(cb){
//   var win = buildWindow();
//   win.on('minimize', function() { cb(); });
//   win.minimize();
//   win.close();
// });

// UnitTest("the 'deminimize' event is fired on deminimize", function(cb){
//   var win = buildWindow();
//   win.on('deminimize', function() { cb(); });
//   win.minimize();
//   win.deminimize();
//   win.close();
// });

// UnitTest("the 'focus' event is fired on show()", function(cb){
//   var win = buildWindow({chrome: true});
//   win.on('focus', function() { win.close(); cb(); });
//   setTimeout(function(){
//     win.show();
//   },10);
// });

// UnitTest("the 'blur' event is fired on hide()", function(cb){
//   var win = buildWindow({chrome: true});
//   win.on('focus', function() { win.hide(); });
//   win.on('blur', function() { win.close(); cb(); });
//   setTimeout(function(){
//     win.show();
//   },10);
// });

// UnitTest("the 'blur' event is fired on blur", function(cb){
//   var win = buildWindow({chrome: true});
//   win.on('blur', function() { cb(); });
//   win.show();
//   win.hide();
//   win.show();
//   win.close();
// });

// UnitTest("height getter returns the height", function(){
//   var win = buildWindow();
//   var height = win.height;
//   win.close();
//   AssertEqual(height, 900);
// });
