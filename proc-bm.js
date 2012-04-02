
function e(x) { return x; }
// convert to and from a string
//function e(x) { return ("" + x) - 0 }

print("inlined(?)");
milliseconds1 = Date.now(); 
for (i = 0; i < 10000000; i++) {
  e(i);
}
milliseconds2 = Date.now(); 
print(milliseconds2 - milliseconds1);

var f = 0;
f = e;

print("plain");
milliseconds1 = Date.now(); 
for (i = 0; i < 10000000; i++) {
  f(i);
}
milliseconds2 = Date.now(); 
print(milliseconds2 - milliseconds1);


function g(x) { return f(x); }

print("wrapped");
milliseconds1 = Date.now(); 
for (i = 0; i < 10000000; i++) {
  g(i);
}
milliseconds2 = Date.now(); 
print(milliseconds2 - milliseconds1);


function g2(x) { 
  return [f(x), function(y) { return y; } ]; 
}

print("wrapped+values");
milliseconds1 = Date.now(); 
for (i = 0; i < 10000000; i++) {
    var l = g2(i);
    l[1](l[0]);
}
milliseconds2 = Date.now(); 
print(milliseconds2 - milliseconds1);


var h0 = Proxy.createFunction({ }, 
                              function(x) { return f(x); },
                              function() { return 0; }); 

print("proxy");
milliseconds1 = Date.now(); 
for (i = 0; i < 10000000; i++) {
    h0(i);
}
milliseconds2 = Date.now(); 
print(milliseconds2 - milliseconds1);
