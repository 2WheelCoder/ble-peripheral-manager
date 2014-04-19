var BLEPeripheralManager = (function() {

    /**
    * Private Variables
    **/

    var BLEStates = [
            'CBPeripheralManagerStateUnknown',
            'CBPeripheralManagerStateResetting',
            'CBPeripheralManagerStateUnsupported',
            'CBPeripheralManagerStateUnauthorized',
            'CBPeripheralManagerStatePoweredOff',
            'CBPeripheralManagerStatePoweredOn'
        ],
        state;


    /**
    * Public Methods
    **/

    function addService(service, successCallback, errorCallback) {
        var jsonService = JSON.stringify(service);

        cordova.exec(
            function success() {
                function serviceAdded() {
                    console.log('service added');
                    unsubscribe(subscription);
                    if(successCallback) {
                        successCallback();
                    }
                }

                var subscription = subscribe('didAddService', serviceAdded);
            },
            function error(err) {
                alert('BLE Peripheral Manager Error');
                errorCallback();
            },
            'BLEPeripheralManager',
            'addService',
            [jsonService]
        );
    }

    function getState() {
        return state;
    }

    function logState(BLEstate) {
        state = BLEStates[BLEstate];
        console.log('BLE state: ', state);
    }

    function removeAllServices() {
        cordova.exec(
            function success() {
                console.log('all services removed');
            },
            function error(err) {
                alert('BLE Peripheral Manager Error');
            },
            'BLEPeripheralManager',
            'removeAllServices',
            []
        );
    }

    function startAdvertising(localNameKey, successCallback, errorCallback) {
        var localNameKey = localNameKey ? localNameKey : 'missing-service-name';

        cordova.exec(
            function success() {
                function didStartAdvertising(topic) {
                    console.log('Peripheral Manager Did Start Advertising');
                    unsubscribe(subscription);
                    if (successCallback) {
                        successCallback();
                    }
                }

                var subscription = subscribe('didStartAdvertising', didStartAdvertising);
            },
            function error(err) {
                alert('BLE Peripheral Manager Error');
            },
            'BLEPeripheralManager',
            'startAdvertising',
            [localNameKey]
        );
    }

    function stopAdvertising() {
        cordova.exec(
            function success() {
                console.log('stopped advertising');
            },
            function error(err) {
                alert('BLE Peripheral Manager Error');
            },
            'BLEPeripheralManager',
            'stopAdvertising',
            []
        );
    }


    /**
    * Pub/Sub Implementation
    **/

    var topics = {};
    var subUid = -1;

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

    return {
        addService: addService,
        getState: getState,
        removeAllServices: removeAllServices,
        startAdvertising: startAdvertising,
        stopAdvertising: stopAdvertising,

        // Public for the purposes of calling from Objective-C
        logState: logState,
        publish: publish
    };

})();

module.exports = BLEPeripheralManager;