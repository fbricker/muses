package org.xiph.fogg;

import org.xiph.system.Bytes;

class SyncState {
    /*
     * generated source for SyncState
     */
    public var data : Bytes;
    var storage : Int;
    var fill : Int;
    var returned : Int;
    var unsynced : Int;
    var headerbytes : Int;
    var bodybytes : Int;

    // modifiers: public
    public function clear() : Int {
        data = null;
        return 0;
    }

    // modifiers: public
    public function buffer(size : Int) : Int {
        if (returned != 0) {
            fill -= returned;
            if (fill > 0) {
                System.bytescopy(data, returned, data, 0, fill);
            };
            returned = 0;
        };
        if (size > (storage - fill)) {
            var newsize : Int = (size + fill) + 4096;
            if (data != null) {
                // var foo : Bytes = System.alloc(newsize);
                // System.arraycopy(data, 0, foo, 0, data.length);
                // data = foo;
                System.resize(data, newsize);
            }
            else{
                data = System.alloc(newsize);
            };
            storage = newsize;
        };
        return fill;
    }

    // modifiers: public
    public function wrote(bytes : Int) : Int {
        if ((fill + bytes) > storage) {
            return -1;
        };
        fill += bytes;
        return 0;
    }

    // discarded initializer: 'Page()';
    private var _pageseek : Page;
    // discarded initializer: 'Bytes.alloc(4)';
    private var chksum : Bytes;

    // modifiers: public
    public function pageseek(og : Page) : Int {
        // FIXME: shadows variable 'pageseek';
        var page : Int = returned;
        var next : Int;
        var bytes : Int = fill - returned;

        if (headerbytes == 0) {
            var _headerbytes : Int;
            var i : Int;
            if (bytes < 27) {
                return 0;
            };

            if ((((data[page] != 'O'.charCodeAt(0)) || (data[page + 1] != 'g'.charCodeAt(0))) || (data[page + 2] != 'g'.charCodeAt(0))) || (data[page + 3] != 'S'.charCodeAt(0))) {
                headerbytes = 0;
                bodybytes = 0;
                next = 0;
                // for-while;
                var ii : Int = 0;
                while (ii < (bytes - 1)) {
                    if (data[(page + 1) + ii] == 'O'.charCodeAt(0)) {
                        next = ((page + 1) + ii);
                        break;
                    };
                    ii++;
                };
                if (next == 0) {
                    next = fill;
                };
                returned = next;
                return -(next - page);
            };
            _headerbytes = ((data[page + 26] & 0xff) + 27);
            if (bytes < _headerbytes) {
                return 0;
            };

            i = 0;
            while (i < (data[page + 26] & 0xff)) {
                bodybytes += (data[(page + 27) + i] & 0xff);
                i++;
            };
            headerbytes = _headerbytes;
        };

        if ((bodybytes + headerbytes) > bytes) {
            return 0;
        };

        // synchronized (chksum) ...;
        {
            System.bytescopy(data, page + 22, chksum, 0, 4);
            data[page + 22] = 0;
            data[page + 23] = 0;
            data[page + 24] = 0;
            data[page + 25] = 0;
            var log : Page = _pageseek;
            log.header_base = data;
            log.header = page;
            log.header_len = headerbytes;
            log.body_base = data;
            log.body = (page + headerbytes);
            log.body_len = bodybytes;
            log.checksum();
            if ((((chksum[0] != data[page + 22]) || (chksum[1] != data[page + 23])) || (chksum[2] != data[page + 24])) || (chksum[3] != data[page + 25])) {
                System.bytescopy(chksum, 0, data, page + 22, 4);
                headerbytes = 0;
                bodybytes = 0;
                next = 0;
                // for-while;
                var ii : Int = 0;
                while (ii < (bytes - 1)) {
                    if (data[(page + 1) + ii] == 'O'.charCodeAt(0)) {
                        next = ((page + 1) + ii);
                        break;
                    };
                    ii++;
                };
                if (next == 0) {
                    next = fill;
                };
                returned = next;
                return -(next - page);
            };
        };
        page = returned;
        if (og != null) {
            og.header_base = data;
            og.header = page;
            og.header_len = headerbytes;
            og.body_base = data;
            og.body = (page + headerbytes);
            og.body_len = bodybytes;
        };
        unsynced = 0;
        returned += (bytes = (headerbytes + bodybytes));
        headerbytes = 0;
        bodybytes = 0;
        return bytes;
    }

    // modifiers: public
    public function pageout(og : Page) : Int {
        while (true) {
            var ret : Int = pageseek(og);
            if (ret > 0) {
                return 1;
            };
            if (ret == 0) {
                return 0;
            };
            if (unsynced == 0) {
                unsynced = 1;
                return -1;
            };
        };
        return -1; // ??!...
    }

    // modifiers: public
    public function reset() : Int {
        fill = 0;
        returned = 0;
        unsynced = 0;
        headerbytes = 0;
        bodybytes = 0;
        return 0;
    }

    // modifiers: public
    public function init() : Void {
        reset();
        storage = 0;
    }

    public function new() {
        _pageseek = new Page();
        chksum = System.alloc(4);
    }
}
