// SETTINGS
var grav = -0.01;
var coef_absorb = -0.8;
var maxDeg = 30;

// BTN INFO
var info_top = [0, 0];
var info_profile = [0, 0];

// EACH BTNS ACTION
function load_top(){
  $("#contents").load("top.html");
};

function load_profile(){
  $("#contents").load("profile.html");
};

function liftUp_top(){
  var img = $(btn_mount_top)
  info_top = liftUp(img, info_top);
}
function liftUp_profile(){
  var img = $(btn_mount_profile)
  info_profile = liftUp(img, info_profile);
}
function liftUp_tech(){
  var img = $(btn_mount_tech)
  info_tech = liftUp(img, info_tech);
}

function fall_top(){
  var img = $(btn_mount_top)
  info_top = fall(img, info_top);
}
function fall_profile(){
  var img = $(btn_mount_profile)
  info_profile = fall(img, info_profile);
}
function fall_tech(){
  var img = $(btn_mount_tech)
  info_tech = fall(img, info_tech);
}


// BTN ACTION
function liftUp(img, info){
  function liftUp_move(){
    if(info[1] != 0){
      clearInterval(g)
    }
    if(info[0] <= 1){
      info[0] = info[0] + 0.1;
      deg = maxDeg * info[0] * -1;
      img.css("-webkit-transform", "rotate("+deg+"deg)");
    }else{
      clearInterval(g)
    }
  }
  var g = setInterval(liftUp_move, 10);
  return info
}

function fall(img, info){
  function fall_move(){
    info[1] = info[1] + grav;
    info[0] = info[0] + info[1];
    if(info[0] < 0){
      info[0] = 0;
      info[1] = info[1] * coef_absorb;
    }
    if(Math.abs(info[1])<0.1　&& info[0]<0.1){
      info[0] = 0;
      info[1] = 0;
      clearInterval(h)
    }
    deg = maxDeg * info[0] * -1;
    img.css("-webkit-transform", "rotate("+deg+"deg)");
  }
  var h = setInterval(fall_move, 10);
  return info
}


/*
// rotation functions
$(function(){
  //https://jugedred.net/2016/01/10/180427
	// ボタンをクリックした時
	$('btn_mount_top').click(function(){
    alert('test');
		// degという変数を0から360まで3秒かけて変化させる。
		$({deg:0}).animate({deg:360}, {
			duration:3000,
			// 途中経過
			progress:function() {
				$('btn_mount_top').css({
					transform:'rotate(' + this.deg + 'deg)'
				});
			},
			// アニメーション完了
			complete:function() {
				alert('1回転しました！');
			}
		});
	});
});
*/

/*
function fall(){
  var grav = -0.05;
  var coef_absorb = -0.8;
  var position = 1;
  var speed = 0;
  while speed < 0.01 & position < 0.01
    speed = speed + grav;
    position = position + speed;
    if position < 0
      speed = speed * coef_absorb;
    end
  end
}

function liftUp(){

}
*/
