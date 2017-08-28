<?php

require 'TwistOAuth.phar';

$consumerKey = "OMGkqmbjjVJjpBtPCqnBLqYQ9";
$consumerSecret = "6LDbCDz5PsSLqAxAoyqsIPVODuovCnG9sjtOnoI6iDBXLal2k1";
$accessToken = "99876091266977792-szNGtLafWQjzp8Q3nH9X9YBAXkrATa3";
$accessTokenSecret = "bItoHOhk9CbzKOtuIXuA4BXJO5j6ItTm5xrcPl3WbQiAm";

$connection = new TwistOAuth($consumerKey, $consumerSecret, $accessToken, $accessTokenSecret);

$user_params = ['count' => '10'];
$user = $connection->get('statuses/user_timeline', $user_params);

function disp_tweet($value, $text){
    $icon_url = $value->user->profile_image_url;
    $screen_name = $value->user->screen_name;
    $updated = date('Y/m/d H:i', strtotime($value->created_at));
    $tweet_id = $value->id_str;
    $url = 'https://twitter.com/' . $screen_name . '/status/' . $tweet_id;

    echo '<div class="tweetbox">' . PHP_EOL;
    echo '<div class="thumb">' . '<img alt="" src="' . $icon_url . '">' . '</div>' . PHP_EOL;
    echo '<div class="meta"><a target="_blank" href="' . $url . '">' . $updated . '</a>' . '<br>@' . $screen_name .'</div>' . PHP_EOL;
    echo '<div class="tweet">' . $text . '</div>' . PHP_EOL;
    echo '</div>' . PHP_EOL;
}
