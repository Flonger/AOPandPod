hookMethod("ViewController","btnClick",2,function(instance,originalInvocation,arguments){
            hookClassMethod("ViewController","test");

            var color = new Array(Math.random(),Math.random(),Math.random(),Math.random());
            var uicolor = hookClassMethod('UIColor','colorWithRed:green:blue:alpha:',color);
            var view = hookInstanceMethod(instance,'btn');
            hookInstanceMethod(view,'setBackgroundColor:',new Array(uicolor));

            });
