import '../main.dart';


//appName need to change in 3 places
const appName = 'HAWRAA';
//the following just need to change in this file
const storeId = '39447';
const AUTHORIZATION_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzMzYiLCJqdGkiOiI5NTgyZTBlMGJmNGMxOTIzZTIwYjhkZmU2MjY3YmYxNjIzNmY4ZDZmYmQ4YWU4OTBkN2JlZTg0NWU4NDVkNDYzZGM1ZWMzZDc2ODc4YjY0ZCIsImlhdCI6MTY1MzM4ODQ1NS4wNzg1MzMsIm5iZiI6MTY1MzM4ODQ1NS4wNzg1MzgsImV4cCI6MTY4NDkyNDQ1NS4wMzMwMzcsInN1YiI6IjQyNDA4Iiwic2NvcGVzIjpbInRoaXJkX2FjY291bnRfcmVhZCIsInRoaXJkX3ZhdF9yZWFkIiwidGhpcmRfY2F0ZWdvcmllc19yZWFkIiwidGhpcmRfY3VzdG9tZXJzX3JlYWQiLCJ0aGlyZF9vcmRlcl9yZWFkIiwidGhpcmRfY291cG9uc193cml0ZSIsInRoaXJkX2RlbGl2ZXJ5X29wdGlvbnNfcmVhZCIsInRoaXJkX2FiYW5kb25lZF9jYXJ0c19yZWFkIiwidGhpcmRfcGF5bWVudF9yZWFkIiwidGhpcmRfd2ViaG9va19yZWFkIiwidGhpcmRfcHJvZHVjdF9yZWFkIiwidGhpcmRfY291bnRyaWVzX3JlYWQiLCJ0aGlyZF9jYXRhbG9nX3dyaXRlIiwidGhpcmRfc3Vic2NyaXB0aW9uX3JlYWQiLCJ0aGlyZF9pbnZlbnRvcnlfcmVhZCJdfQ.YUrQhYXyi1tT3-j3V-7YV0DrVy63ox2tG66bZYJbIWzY3EkSpmDVL5o4oezutc3k-deJYnz20O5KfjdXd4FQgDh-JkrkDXxK7oiW6YsA0f3ys-Qrv9FcjCQBOuhWmMmjPf63zWrDOY8sYotnKfU_WxwyPAKPhcwKnZy5SG3gL3jaOdrHXCxYiQ66qrLg9VG-ZZJ1Ki99KgIrrfyp-2yj_AWDIK--1OO44fKVCL-9Lch6UE0XK3wdw11qkHfANbHOH5_dl-WbK9zZJAJsrgjf0ITazhbSY1gTt7P-qHXy0-OZekbnFDXLHtOdXESNEhRJwXlTTLmIYtWFT6d9j6iEQj8C0fLO861bvs27rZycam0xgYTJ3bbXVtgKKduaziiDUgoTfGl6aH8qSDEzubHOSAHKFvX__AqJPxGKkuR0RyMfsBucNzZULJnKmnAZ5_lNKvXnDBO-hfTJj4wmIsBXzKCJBHxg9-TsoXYp3bgTIBnIxMkQNsxI9ky5tsU_BpyOGqbxZfZQGdDjCvkYb2KAiOmE4lcCKQNQnYXyj_NYpdSutsDSnmgugcmQWYZN0gDaCjYRK17GW_mrKz1oq72J-weizCk3f5hz2s1Z6-lHCohAqC2TBZmw3iVRNGbeWsUpkieZie_cblimm-22bYDc1UrZ84gwhTV6e4QuWRChztc";
const ACCESS_TOKEN = 'eyJpdiI6Ik1URHVUalp2aXpzSVZQTitWMWpUQ3c9PSIsInZhbHVlIjoiRmptR1gwS0p4bXlUZ0JsenRXZjUyK045NzR3MTZlZHRHZGQreG9GQ2M2Q3ZBSlpBcUp3QWxkT1o0RDkzT0cvaGdOZzFXS2M4aWUvZ2FOZ0E4K3FRVmpxYkFDcENLRU9IaVhybFdWYnVqb0hSeUFHNHJ5S0NGM1NHZGsvYmQzUE4vZ0l0QmhCQWxkODU1Rll4L29UM1dlUkR6VjBUYUZqQ002OVRBdWNGUDJ3b20veGZESC8rdmVwVGl0UklUOUx4clFPS0wvblUvdm5EYVFQdmF2SG5DTU5NaGdIK2h5RTBKTlN3aUdYb3JaND0iLCJtYWMiOiJkOGFjNWY1OTIyMjM0YzlhYjk5MmI1NGQ2Y2FiZmY5ZjI4MGJiMzczNDNhZjY0ODEwNmFkMmVlNWM4MzRjNThiIiwidGFnIjoiIn0=';
const OneSignalAppId = 'd07dea5e-7045-4b15-9f18-8e2296376957';
const storeUrl   = 'https://hawraaabaya.com';
const appsBunchesUrl = 'https://bit.ly/3y5ddiV';
// Share App link in stores
const shareLink = 'https://hawraaabaya.page.link/rniX';


//static strings
const currency = 'SAR';
const baseUrl    = 'https://api.zid.sa/v2/';
const baseUrlV1  = 'https://api.zid.sa/v1/';
const catalogUrl = 'https://api.zid.sa/';
const accept = 'application/json';
const SECRET_ENCRYPT_KEY = '479cb4c8f5ac23e51fd3e1dee0ac14c6';
const softThemeId = 'f9f0914d-3c58-493b-bd83-260ed3cb4e82';
const eshraqThemeId = '8ba6ae26-32ea-4271-81b2-0d9d6804a473';
const ghassqThemeId = '20e10dd5-cf9d-4a6c-87d3-bfecd5a7b4d6';

//remote config keys
const WA_ACCOUNT_KEY = 'WA_ACCOUNT';
const WA_ACCOUNT_ENABLE_KEY = 'WA_ACCOUNT_ENABLE';
const WA_PRODUCT_KEY = 'WA_PRODUCT';
const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const AUTHORIZATION_TOKEN_KEY = 'AUTHORIZATION_TOKEN';


