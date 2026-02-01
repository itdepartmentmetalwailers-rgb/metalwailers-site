'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "f996c07dd57059b64e8cf9ac694a1553",
"assets/AssetManifest.bin.json": "975920b7be0953f75394b04376c51b02",
"assets/AssetManifest.json": "6146f057fac20b631a719de2d8a988a1",
"assets/assets/images/balancinadonew.png": "71cde42cae6fa6cea8fe982e5b8e39cb",
"assets/assets/images/balancinadonew2.png": "6666c4d1aff026c733406d90f564aa9d",
"assets/assets/images/cilindrado.png": "8cd63f291fc3ea0136fb050b8a3b2694",
"assets/assets/images/cilindrado2.png": "f2dcf1bfd884bf05053142eda225dcca",
"assets/assets/images/curvado.png": "4063b1f65d526b3b215b6c8cf27acf0d",
"assets/assets/images/curvado2.png": "8c118ac7636d5b1a4d9914648e825aac",
"assets/assets/images/curvadonew.png": "b71053b10a99b6b9b8eef76b0ef98282",
"assets/assets/images/dobladoranew.png": "f95cd3f6171f868eca8c9b3752286282",
"assets/assets/images/dobladoranew2.png": "4f883bb81a1d24da8231e984ec128130",
"assets/assets/images/guillotinado.png": "e7696df0b91a8ab6365830dd44ef89be",
"assets/assets/images/guillotinado2.png": "480b1fc532a8c4a5a46515ea7a2aa12d",
"assets/assets/images/guillotinadonew.png": "535d190254505202cf33846d874dbf2e",
"assets/assets/images/guillotinadonew2.png": "eee891555fab53141325096e56910492",
"assets/assets/images/homesoldadura.png": "ef96bcf14de4b977e2137e4cf6900148",
"assets/assets/images/homesoldadura2.png": "7f32b52719a8a531c7a06a51822d9535",
"assets/assets/images/inicio1.png": "fddad2865be111560fda80384d2235b4",
"assets/assets/images/inicio2.png": "f18c061ef31f3df8f75a72f96d252d5d",
"assets/assets/images/inicio3.png": "aad78809cddb75abf3ce1de2762a4e97",
"assets/assets/images/inicio4.png": "6836fb0b4ea0485a2b79e61f13270ba2",
"assets/assets/images/laser.png": "0d1bb1320fe016904916d60d3db0cc85",
"assets/assets/images/laser2.png": "191b1524f9713e7d0a0d1c85eea268db",
"assets/assets/images/pintura.png": "dbc2f2eee2a74831e980bcf0e39ac4b7",
"assets/assets/images/pintura2.png": "3d8e062c6a47473bc84a95500d575730",
"assets/assets/images/plasma.png": "2180ed2a9e9619107bd0070e7ac07f2b",
"assets/assets/images/plasma2.png": "3cec2951403095b459e76bec36982e08",
"assets/assets/images/plegado.png": "fa92b70bc8454dc3b2952420ce5b908d",
"assets/assets/images/plegado2.png": "5e279bc8e7013b01cd05a3d91089df0b",
"assets/assets/images/plegadonew.jpeg": "69bf9f0ad20be2fb31bc9dd066c5f221",
"assets/assets/images/plegadonew2.jpeg": "0b4ededda4d1d1a5eb8c954fbc9d99cc",
"assets/assets/images/punzonado.png": "a46da1de81755eadb5d7f27f8863e5ec",
"assets/assets/images/punzonado2.png": "c21f2c4441104ef9524787ac7fad75d3",
"assets/assets/images/rolado.png": "3018d74cd3e474f7841782ccda1fe375",
"assets/assets/images/rolado2.png": "a20695528f6cb6322af780103172cdfd",
"assets/assets/images/roladonew.png": "0058be2b4f6844f446ba5d360caecbfa",
"assets/assets/images/roladonew2.png": "428fc1f1fc3a1acd64c63ea875f01948",
"assets/assets/images/soldadura.png": "5f082c65c772f84a3787bf614d0606a5",
"assets/assets/images/soldadura2.png": "b37d8b045c0609efa300e591737a4bc3",
"assets/assets/images/soldadura3.png": "fc3a4174fee93df6e3ab61208e9639af",
"assets/assets/logo/header_logo.png": "e904a5a6385e7073970a91f4ff2eb509",
"assets/assets/logo/Logo-Horizontal.png": "edf6849639c8f3778d787f133f583904",
"assets/assets/logo/logo.png": "27ddd9d7607cc11de4b2c988c376ac04",
"assets/assets/logo/logo.svg": "1d88b386f7610dce1dede5403d2f589f",
"assets/assets/logo/logoweb.png": "e8989c15581f53da4e2676e2089065eb",
"assets/assets/logo/logowebbbbb.png": "3687b074a545ecec7f58eae300200d7e",
"assets/assets/logo/logo_metalwailer.svg": "249bcbe375dab50898ea12816136a4c1",
"assets/assets/logo/loguito.svg": "fce3268918222877d2efb787e153f28b",
"assets/assets/logo/loguitoo.png": "ef1a66cb462df00a5178befe5e9e5aea",
"assets/assets/logo/webmw.png": "84d7b43db17cd94680afaead55e6afa1",
"assets/assets/lottie/success.json": "0304f0075a7aade4e07a1e850e4dc9d0",
"assets/FontManifest.json": "67a28da3784fc091c2f816d615fbf08a",
"assets/fonts/MaterialIcons-Regular.otf": "cb2607c9f8eb686c01f6b01f12d67ffc",
"assets/NOTICES": "43d6e69f4c1a8f5411788ab6703d5ea2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "a53baa14911df76a48506ba22ea66b91",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "bf21cd8fd775a3c59fd53afdee39e0e6",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "95aa81aff62e03dbedd688740741f730",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "627c881554f6c405635db230331948d1",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "a1d676f7748a4ebd8d51ed4633a7fb17",
"icons/Icon-192.png": "6980f003476abb4ac31f71a10702b2ab",
"icons/Icon-512.png": "f86d039353342a25a6f27fc31c82043b",
"icons/Icon-maskable-192.png": "6980f003476abb4ac31f71a10702b2ab",
"icons/Icon-maskable-512.png": "f86d039353342a25a6f27fc31c82043b",
"index.html": "57e03b499bce19a1a50da44addeb55c5",
"/": "57e03b499bce19a1a50da44addeb55c5",
"main.dart.js": "f3e544fe01d8ac74babb8b26e8243e52",
"manifest.json": "dd5d65cce38d81b6d4090ecbb5b7aec5",
"robots.txt": "d29834df453faec2bcdfffa6f816bb88",
"sitemap.xml": "1c64dbb17a6a8ab788e5016488d8c98f",
"vercel.json": "7708fbf29b99cd92c2a778d60001c5ba",
"version.json": "882b3d41e910386c30e12f4b095956e6"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
