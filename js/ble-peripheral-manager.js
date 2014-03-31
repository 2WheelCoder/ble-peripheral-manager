var BLEPeripheralManager = (function() {
    var topics = {};
    var subUid = -1;
    var BLEStates = [
        'CBPeripheralManagerStateUnknown',
        'CBPeripheralManagerStateResetting',
        'CBPeripheralManagerStateUnsupported',
        'CBPeripheralManagerStateUnauthorized',
        'CBPeripheralManagerStatePoweredOff',
        'CBPeripheralManagerStatePoweredOn'
    ];

    function addService(serviceUUID, servicePrimary, characteristics) {
        var serviceUUID = serviceUUID ? serviceUUID : '51E7D768-92B2-49BE-AACC-FA22233128AB',
            characteristicUUID = characteristicUUID ? characteristicUUID : '95749716-6B14-4ECD-B51D-FBCE46DD0538';

        cordova.exec(
            function callback(data) {
                subscribe('didAddService', serviceAdded);
            },
            function errorHandler(err) {
                alert('Error: ', err);
            },
            'BLEPeripheralManager',
            'addService',
            // characteristics is an array of characteristic arrays
            // [[characteristic1UUID, characteristic1Value], [characteristic2UUID, characteristic2Value]]
            [serviceUUID, servicePrimary, characteristics]
        );
    }

    function init() {
        cordova.exec(
            function callback(data) {
                subscribe('peripheralManagerDidUpdateState', updateState);
            },
            function errorHandler(err) {
                alert('Error: ', err);
            },
            'BLEPeripheralManager',
            'initPeripheralManager',
            []
         );
    }

    function publish(topic, args) {
        if ( !topics[topic] ) {
            return false;
        }

        var subscribers = topics[topic],
            len = subscribers ? subscribers.length : 0;

        while (len--) {
            subscribers[len].func( topic, args );
        }

        return this;
    }

    function serviceAdded() {
        console.log('service added');
    }

    function startAdvertising(localNameKey) {
        var localNameKey = localNameKey ? localNameKey : 'missing-service-name';

        cordova.exec(
            function callback(data) {
                console.log('advertising');
            },
            function errorHandler(err) {
                alert('Error: ', err);
            },
            'BLEPeripheralManager',
            'startAdvertising',
            [localNameKey]
        );
    }

    function stopAdvertising() {
        cordova.exec(
            function callback(data) {
                console.log('stopped advertising');
            },
            function errorHandler(err) {
                alert('Error: ', err);
            },
            'BLEPeripheralManager',
            'stopAdvertising',
            []
        );
    }

    function subscribe(topic, func) {
        if (!topics[topic]) {
            topics[topic] = [];
        }

        var token = ( ++subUid ).toString();
        topics[topic].push({
            token: token,
            func: func
        });
        return token;
    }

    function unsubscribe(token) {
        for ( var m in topics ) {
            if ( topics[m] ) {
                for ( var i = 0, j = topics[m].length; i < j; i++ ) {
                    if ( topics[m][i].token === token ) {
                        topics[m].splice( i, 1 );
                        return token;
                    }
                }
            }
        }
        return this;
    }

    function updateState(topic, state) {
        var state = BLEStates[state];
        console.log("state: ", state);
    }

    return {
        addService: addService,
        init: init,
        publish: publish,
        startAdvertising: startAdvertising,
        stopAdvertising: stopAdvertising
    };

})();

module.exports = BLEPeripheralManager;
