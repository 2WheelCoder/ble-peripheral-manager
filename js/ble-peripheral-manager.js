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
        var that = this,
            serviceUUID = serviceUUID ? serviceUUID : '51E7D768-92B2-49BE-AACC-FA22233128AB',
            characteristicUUID = characteristicUUID ? characteristicUUID : '95749716-6B14-4ECD-B51D-FBCE46DD0538';

            // 11EE5D06-923A-4F62-AFB2-62F3BFE27BD3
            // 5E2A7AED-B41F-4215-AFC9-CF97353A0425

            // BLEPeripheralManager.addService(null, true, [['95749716-6B14-4ECD-B51D-FBCE46DD0538', 'service1Characteristic1']])
            // BLEPeripheralManager.addService('11EE5D06-923A-4F62-AFB2-62F3BFE27BD3', false, [['5E2A7AED-B41F-4215-AFC9-CF97353A0425', 'service2Characteristic1']])

        cordova.exec(
            function callback(data) {
                this.subscribe('didAddService', that.serviceAdded);
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
        var that = this;

        cordova.exec(
            function callback(data) {
                this.subscribe('peripheralManagerDidUpdateState', that.updateState);
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
        if ( !this.topics[topic] ) {
            return false;
        }

        var subscribers = this.topics[topic],
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
            // Register the callback handler
            function callback(data) {
                console.log('advertising');
            },
            // Register the errorHandler
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
            // Register the errorHandler
            function errorHandler(err) {
                alert('Error: ', err);
            },
            'BLEPeripheralManager',
            'stopAdvertising',
            []
        );
    }

    function subscribe(topic, func) {
        if (!this.topics[topic]) {
            this.topics[topic] = [];
        }

        var token = ( ++this.subUid ).toString();
        this.topics[topic].push({
            token: token,
            func: func
        });
        return token;
    }

    function unsubscribe(token) {
        for ( var m in this.topics ) {
            if ( this.topics[m] ) {
                for ( var i = 0, j = this.topics[m].length; i < j; i++ ) {
                    if ( this.topics[m][i].token === token ) {
                        this.topics[m].splice( i, 1 );
                        return token;
                    }
                }
            }
        }
        return this;
    }

    function updateState(topic, state) {
        this.state = BLEStates[state];
        console.log("state: ", BLEPeripheralManager.state);
    }

    return {
        addService: addService,
        init: init,
        startAdvertising: startAdvertising,
        stopAdvertising: stopAdvertising
    };

})();

module.exports = BLEPeripheralManager;
