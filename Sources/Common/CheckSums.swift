// Copyright (c) 2017 Timofey Solomko
// Licensed under MIT License
//
// See LICENSE for license information

import Foundation

struct CheckSums {

    // MARK: Functions

    static func crc32(_ array: [UInt8], prevValue: UInt32 = 0) -> UInt32 {
        var crc = ~prevValue
        for byte in array {
            let index = (crc & 0xFF) ^ (UInt32(truncatingIfNeeded: byte))
            crc = CheckSums.crc32table[index.toInt()] ^ (crc >> 8)
        }
        return ~crc
    }

    static func crc32(_ data: Data, prevValue: UInt32 = 0) -> UInt32 {
        var crc = ~prevValue
        for byte in data {
            let index = (crc & 0xFF) ^ (UInt32(truncatingIfNeeded: byte))
            crc = CheckSums.crc32table[index.toInt()] ^ (crc >> 8)
        }
        return ~crc
    }

    static func bzip2CRC32(_ data: Data) -> UInt32 {
        var crc: UInt32 = 0xFFFFFFFF
        for byte in data {
            let index = UInt32(byte)
            crc = (crc << 8) ^ CheckSums.bzip2CRC32table[Int((crc >> 24) ^ index)]
        }
        return ~crc
    }

    static func crc64(_ data: Data) -> UInt64 {
        var crc: UInt64 = ~0
        for byte in data {
            let index = (crc & 0xFF) ^ (UInt64(truncatingIfNeeded: byte))
            crc = CheckSums.crc64table[index.toInt()] ^ (crc >> 8)
        }
        return ~crc
    }

    static func adler32(_ data: Data) -> Int {
        let base = 65521
        var s1 = 1
        var s2 = 0
        for byte in data {
            s1 = (s1 + byte.toInt()) % base
            s2 = (s2 + s1) % base
        }
        return (s2 << 16) + s1
    }

    // MARK: Tables

    private static let crc32table: [UInt32] =
        [0x00000000, 0x77073096, 0xEE0E612C, 0x990951BA, 0x076DC419, 0x706AF48F, 0xE963A535, 0x9E6495A3,
         0x0EDB8832, 0x79DCB8A4, 0xE0D5E91E, 0x97D2D988, 0x09B64C2B, 0x7EB17CBD, 0xE7B82D07, 0x90BF1D91,
         0x1DB71064, 0x6AB020F2, 0xF3B97148, 0x84BE41DE, 0x1ADAD47D, 0x6DDDE4EB, 0xF4D4B551, 0x83D385C7,
         0x136C9856, 0x646BA8C0, 0xFD62F97A, 0x8A65C9EC, 0x14015C4F, 0x63066CD9, 0xFA0F3D63, 0x8D080DF5,
         0x3B6E20C8, 0x4C69105E, 0xD56041E4, 0xA2677172, 0x3C03E4D1, 0x4B04D447, 0xD20D85FD, 0xA50AB56B,
         0x35B5A8FA, 0x42B2986C, 0xDBBBC9D6, 0xACBCF940, 0x32D86CE3, 0x45DF5C75, 0xDCD60DCF, 0xABD13D59,
         0x26D930AC, 0x51DE003A, 0xC8D75180, 0xBFD06116, 0x21B4F4B5, 0x56B3C423, 0xCFBA9599, 0xB8BDA50F,
         0x2802B89E, 0x5F058808, 0xC60CD9B2, 0xB10BE924, 0x2F6F7C87, 0x58684C11, 0xC1611DAB, 0xB6662D3D,
         0x76DC4190, 0x01DB7106, 0x98D220BC, 0xEFD5102A, 0x71B18589, 0x06B6B51F, 0x9FBFE4A5, 0xE8B8D433,
         0x7807C9A2, 0x0F00F934, 0x9609A88E, 0xE10E9818, 0x7F6A0DBB, 0x086D3D2D, 0x91646C97, 0xE6635C01,
         0x6B6B51F4, 0x1C6C6162, 0x856530D8, 0xF262004E, 0x6C0695ED, 0x1B01A57B, 0x8208F4C1, 0xF50FC457,
         0x65B0D9C6, 0x12B7E950, 0x8BBEB8EA, 0xFCB9887C, 0x62DD1DDF, 0x15DA2D49, 0x8CD37CF3, 0xFBD44C65,
         0x4DB26158, 0x3AB551CE, 0xA3BC0074, 0xD4BB30E2, 0x4ADFA541, 0x3DD895D7, 0xA4D1C46D, 0xD3D6F4FB,
         0x4369E96A, 0x346ED9FC, 0xAD678846, 0xDA60B8D0, 0x44042D73, 0x33031DE5, 0xAA0A4C5F, 0xDD0D7CC9,
         0x5005713C, 0x270241AA, 0xBE0B1010, 0xC90C2086, 0x5768B525, 0x206F85B3, 0xB966D409, 0xCE61E49F,
         0x5EDEF90E, 0x29D9C998, 0xB0D09822, 0xC7D7A8B4, 0x59B33D17, 0x2EB40D81, 0xB7BD5C3B, 0xC0BA6CAD,
         0xEDB88320, 0x9ABFB3B6, 0x03B6E20C, 0x74B1D29A, 0xEAD54739, 0x9DD277AF, 0x04DB2615, 0x73DC1683,
         0xE3630B12, 0x94643B84, 0x0D6D6A3E, 0x7A6A5AA8, 0xE40ECF0B, 0x9309FF9D, 0x0A00AE27, 0x7D079EB1,
         0xF00F9344, 0x8708A3D2, 0x1E01F268, 0x6906C2FE, 0xF762575D, 0x806567CB, 0x196C3671, 0x6E6B06E7,
         0xFED41B76, 0x89D32BE0, 0x10DA7A5A, 0x67DD4ACC, 0xF9B9DF6F, 0x8EBEEFF9, 0x17B7BE43, 0x60B08ED5,
         0xD6D6A3E8, 0xA1D1937E, 0x38D8C2C4, 0x4FDFF252, 0xD1BB67F1, 0xA6BC5767, 0x3FB506DD, 0x48B2364B,
         0xD80D2BDA, 0xAF0A1B4C, 0x36034AF6, 0x41047A60, 0xDF60EFC3, 0xA867DF55, 0x316E8EEF, 0x4669BE79,
         0xCB61B38C, 0xBC66831A, 0x256FD2A0, 0x5268E236, 0xCC0C7795, 0xBB0B4703, 0x220216B9, 0x5505262F,
         0xC5BA3BBE, 0xB2BD0B28, 0x2BB45A92, 0x5CB36A04, 0xC2D7FFA7, 0xB5D0CF31, 0x2CD99E8B, 0x5BDEAE1D,
         0x9B64C2B0, 0xEC63F226, 0x756AA39C, 0x026D930A, 0x9C0906A9, 0xEB0E363F, 0x72076785, 0x05005713,
         0x95BF4A82, 0xE2B87A14, 0x7BB12BAE, 0x0CB61B38, 0x92D28E9B, 0xE5D5BE0D, 0x7CDCEFB7, 0x0BDBDF21,
         0x86D3D2D4, 0xF1D4E242, 0x68DDB3F8, 0x1FDA836E, 0x81BE16CD, 0xF6B9265B, 0x6FB077E1, 0x18B74777,
         0x88085AE6, 0xFF0F6A70, 0x66063BCA, 0x11010B5C, 0x8F659EFF, 0xF862AE69, 0x616BFFD3, 0x166CCF45,
         0xA00AE278, 0xD70DD2EE, 0x4E048354, 0x3903B3C2, 0xA7672661, 0xD06016F7, 0x4969474D, 0x3E6E77DB,
         0xAED16A4A, 0xD9D65ADC, 0x40DF0B66, 0x37D83BF0, 0xA9BCAE53, 0xDEBB9EC5, 0x47B2CF7F, 0x30B5FFE9,
         0xBDBDF21C, 0xCABAC28A, 0x53B39330, 0x24B4A3A6, 0xBAD03605, 0xCDD70693, 0x54DE5729, 0x23D967BF,
         0xB3667A2E, 0xC4614AB8, 0x5D681B02, 0x2A6F2B94, 0xB40BBE37, 0xC30C8EA1, 0x5A05DF1B, 0x2D02EF8D]

    private static let bzip2CRC32table: [UInt32] =
        [0x00000000, 0x04C11DB7, 0x09823B6E, 0x0D4326D9, 0x130476DC, 0x17C56B6B, 0x1A864DB2, 0x1E475005,
         0x2608EDB8, 0x22C9F00F, 0x2F8AD6D6, 0x2B4BCB61, 0x350C9B64, 0x31CD86D3, 0x3C8EA00A, 0x384FBDBD,
         0x4C11DB70, 0x48D0C6C7, 0x4593E01E, 0x4152FDA9, 0x5F15ADAC, 0x5BD4B01B, 0x569796C2, 0x52568B75,
         0x6A1936C8, 0x6ED82B7F, 0x639B0DA6, 0x675A1011, 0x791D4014, 0x7DDC5DA3, 0x709F7B7A, 0x745E66CD,
         0x9823B6E0, 0x9CE2AB57, 0x91A18D8E, 0x95609039, 0x8B27C03C, 0x8FE6DD8B, 0x82A5FB52, 0x8664E6E5,
         0xBE2B5B58, 0xBAEA46EF, 0xB7A96036, 0xB3687D81, 0xAD2F2D84, 0xA9EE3033, 0xA4AD16EA, 0xA06C0B5D,
         0xD4326D90, 0xD0F37027, 0xDDB056FE, 0xD9714B49, 0xC7361B4C, 0xC3F706FB, 0xCEB42022, 0xCA753D95,
         0xF23A8028, 0xF6FB9D9F, 0xFBB8BB46, 0xFF79A6F1, 0xE13EF6F4, 0xE5FFEB43, 0xE8BCCD9A, 0xEC7DD02D,
         0x34867077, 0x30476DC0, 0x3D044B19, 0x39C556AE, 0x278206AB, 0x23431B1C, 0x2E003DC5, 0x2AC12072,
         0x128E9DCF, 0x164F8078, 0x1B0CA6A1, 0x1FCDBB16, 0x018AEB13, 0x054BF6A4, 0x0808D07D, 0x0CC9CDCA,
         0x7897AB07, 0x7C56B6B0, 0x71159069, 0x75D48DDE, 0x6B93DDDB, 0x6F52C06C, 0x6211E6B5, 0x66D0FB02,
         0x5E9F46BF, 0x5A5E5B08, 0x571D7DD1, 0x53DC6066, 0x4D9B3063, 0x495A2DD4, 0x44190B0D, 0x40D816BA,
         0xACA5C697, 0xA864DB20, 0xA527FDF9, 0xA1E6E04E, 0xBFA1B04B, 0xBB60ADFC, 0xB6238B25, 0xB2E29692,
         0x8AAD2B2F, 0x8E6C3698, 0x832F1041, 0x87EE0DF6, 0x99A95DF3, 0x9D684044, 0x902B669D, 0x94EA7B2A,
         0xE0B41DE7, 0xE4750050, 0xE9362689, 0xEDF73B3E, 0xF3B06B3B, 0xF771768C, 0xFA325055, 0xFEF34DE2,
         0xC6BCF05F, 0xC27DEDE8, 0xCF3ECB31, 0xCBFFD686, 0xD5B88683, 0xD1799B34, 0xDC3ABDED, 0xD8FBA05A,
         0x690CE0EE, 0x6DCDFD59, 0x608EDB80, 0x644FC637, 0x7A089632, 0x7EC98B85, 0x738AAD5C, 0x774BB0EB,
         0x4F040D56, 0x4BC510E1, 0x46863638, 0x42472B8F, 0x5C007B8A, 0x58C1663D, 0x558240E4, 0x51435D53,
         0x251D3B9E, 0x21DC2629, 0x2C9F00F0, 0x285E1D47, 0x36194D42, 0x32D850F5, 0x3F9B762C, 0x3B5A6B9B,
         0x0315D626, 0x07D4CB91, 0x0A97ED48, 0x0E56F0FF, 0x1011A0FA, 0x14D0BD4D, 0x19939B94, 0x1D528623,
         0xF12F560E, 0xF5EE4BB9, 0xF8AD6D60, 0xFC6C70D7, 0xE22B20D2, 0xE6EA3D65, 0xEBA91BBC, 0xEF68060B,
         0xD727BBB6, 0xD3E6A601, 0xDEA580D8, 0xDA649D6F, 0xC423CD6A, 0xC0E2D0DD, 0xCDA1F604, 0xC960EBB3,
         0xBD3E8D7E, 0xB9FF90C9, 0xB4BCB610, 0xB07DABA7, 0xAE3AFBA2, 0xAAFBE615, 0xA7B8C0CC, 0xA379DD7B,
         0x9B3660C6, 0x9FF77D71, 0x92B45BA8, 0x9675461F, 0x8832161A, 0x8CF30BAD, 0x81B02D74, 0x857130C3,
         0x5D8A9099, 0x594B8D2E, 0x5408ABF7, 0x50C9B640, 0x4E8EE645, 0x4A4FFBF2, 0x470CDD2B, 0x43CDC09C,
         0x7B827D21, 0x7F436096, 0x7200464F, 0x76C15BF8, 0x68860BFD, 0x6C47164A, 0x61043093, 0x65C52D24,
         0x119B4BE9, 0x155A565E, 0x18197087, 0x1CD86D30, 0x029F3D35, 0x065E2082, 0x0B1D065B, 0x0FDC1BEC,
         0x3793A651, 0x3352BBE6, 0x3E119D3F, 0x3AD08088, 0x2497D08D, 0x2056CD3A, 0x2D15EBE3, 0x29D4F654,
         0xC5A92679, 0xC1683BCE, 0xCC2B1D17, 0xC8EA00A0, 0xD6AD50A5, 0xD26C4D12, 0xDF2F6BCB, 0xDBEE767C,
         0xE3A1CBC1, 0xE760D676, 0xEA23F0AF, 0xEEE2ED18, 0xF0A5BD1D, 0xF464A0AA, 0xF9278673, 0xFDE69BC4,
         0x89B8FD09, 0x8D79E0BE, 0x803AC667, 0x84FBDBD0, 0x9ABC8BD5, 0x9E7D9662, 0x933EB0BB, 0x97FFAD0C,
         0xAFB010B1, 0xAB710D06, 0xA6322BDF, 0xA2F33668, 0xBCB4666D, 0xB8757BDA, 0xB5365D03, 0xB1F740B4]

    private static let crc64table: [UInt64] =
        [0x0000000000000000, 0xB32E4CBE03A75F6F, 0xF4843657A840A05B, 0x47AA7AE9ABE7FF34, 0x7BD0C384FF8F5E33,
         0xC8FE8F3AFC28015C, 0x8F54F5D357CFFE68, 0x3C7AB96D5468A107, 0xF7A18709FF1EBC66, 0x448FCBB7FCB9E309,
         0x0325B15E575E1C3D, 0xB00BFDE054F94352, 0x8C71448D0091E255, 0x3F5F08330336BD3A, 0x78F572DAA8D1420E,
         0xCBDB3E64AB761D61, 0x7D9BA13851336649, 0xCEB5ED8652943926, 0x891F976FF973C612, 0x3A31DBD1FAD4997D,
         0x064B62BCAEBC387A, 0xB5652E02AD1B6715, 0xF2CF54EB06FC9821, 0x41E11855055BC74E, 0x8A3A2631AE2DDA2F,
         0x39146A8FAD8A8540, 0x7EBE1066066D7A74, 0xCD905CD805CA251B, 0xF1EAE5B551A2841C, 0x42C4A90B5205DB73,
         0x056ED3E2F9E22447, 0xB6409F5CFA457B28, 0xFB374270A266CC92, 0x48190ECEA1C193FD, 0x0FB374270A266CC9,
         0xBC9D3899098133A6, 0x80E781F45DE992A1, 0x33C9CD4A5E4ECDCE, 0x7463B7A3F5A932FA, 0xC74DFB1DF60E6D95,
         0x0C96C5795D7870F4, 0xBFB889C75EDF2F9B, 0xF812F32EF538D0AF, 0x4B3CBF90F69F8FC0, 0x774606FDA2F72EC7,
         0xC4684A43A15071A8, 0x83C230AA0AB78E9C, 0x30EC7C140910D1F3, 0x86ACE348F355AADB, 0x3582AFF6F0F2F5B4,
         0x7228D51F5B150A80, 0xC10699A158B255EF, 0xFD7C20CC0CDAF4E8, 0x4E526C720F7DAB87, 0x09F8169BA49A54B3,
         0xBAD65A25A73D0BDC, 0x710D64410C4B16BD, 0xC22328FF0FEC49D2, 0x85895216A40BB6E6, 0x36A71EA8A7ACE989,
         0x0ADDA7C5F3C4488E, 0xB9F3EB7BF06317E1, 0xFE5991925B84E8D5, 0x4D77DD2C5823B7BA, 0x64B62BCAEBC387A1,
         0xD7986774E864D8CE, 0x90321D9D438327FA, 0x231C512340247895, 0x1F66E84E144CD992, 0xAC48A4F017EB86FD,
         0xEBE2DE19BC0C79C9, 0x58CC92A7BFAB26A6, 0x9317ACC314DD3BC7, 0x2039E07D177A64A8, 0x67939A94BC9D9B9C,
         0xD4BDD62ABF3AC4F3, 0xE8C76F47EB5265F4, 0x5BE923F9E8F53A9B, 0x1C4359104312C5AF, 0xAF6D15AE40B59AC0,
         0x192D8AF2BAF0E1E8, 0xAA03C64CB957BE87, 0xEDA9BCA512B041B3, 0x5E87F01B11171EDC, 0x62FD4976457FBFDB,
         0xD1D305C846D8E0B4, 0x96797F21ED3F1F80, 0x2557339FEE9840EF, 0xEE8C0DFB45EE5D8E, 0x5DA24145464902E1,
         0x1A083BACEDAEFDD5, 0xA9267712EE09A2BA, 0x955CCE7FBA6103BD, 0x267282C1B9C65CD2, 0x61D8F8281221A3E6,
         0xD2F6B4961186FC89, 0x9F8169BA49A54B33, 0x2CAF25044A02145C, 0x6B055FEDE1E5EB68, 0xD82B1353E242B407,
         0xE451AA3EB62A1500, 0x577FE680B58D4A6F, 0x10D59C691E6AB55B, 0xA3FBD0D71DCDEA34, 0x6820EEB3B6BBF755,
         0xDB0EA20DB51CA83A, 0x9CA4D8E41EFB570E, 0x2F8A945A1D5C0861, 0x13F02D374934A966, 0xA0DE61894A93F609,
         0xE7741B60E174093D, 0x545A57DEE2D35652, 0xE21AC88218962D7A, 0x5134843C1B317215, 0x169EFED5B0D68D21,
         0xA5B0B26BB371D24E, 0x99CA0B06E7197349, 0x2AE447B8E4BE2C26, 0x6D4E3D514F59D312, 0xDE6071EF4CFE8C7D,
         0x15BB4F8BE788911C, 0xA6950335E42FCE73, 0xE13F79DC4FC83147, 0x521135624C6F6E28, 0x6E6B8C0F1807CF2F,
         0xDD45C0B11BA09040, 0x9AEFBA58B0476F74, 0x29C1F6E6B3E0301B, 0xC96C5795D7870F42, 0x7A421B2BD420502D,
         0x3DE861C27FC7AF19, 0x8EC62D7C7C60F076, 0xB2BC941128085171, 0x0192D8AF2BAF0E1E, 0x4638A2468048F12A,
         0xF516EEF883EFAE45, 0x3ECDD09C2899B324, 0x8DE39C222B3EEC4B, 0xCA49E6CB80D9137F, 0x7967AA75837E4C10,
         0x451D1318D716ED17, 0xF6335FA6D4B1B278, 0xB199254F7F564D4C, 0x02B769F17CF11223, 0xB4F7F6AD86B4690B,
         0x07D9BA1385133664, 0x4073C0FA2EF4C950, 0xF35D8C442D53963F, 0xCF273529793B3738, 0x7C0979977A9C6857,
         0x3BA3037ED17B9763, 0x888D4FC0D2DCC80C, 0x435671A479AAD56D, 0xF0783D1A7A0D8A02, 0xB7D247F3D1EA7536,
         0x04FC0B4DD24D2A59, 0x3886B22086258B5E, 0x8BA8FE9E8582D431, 0xCC0284772E652B05, 0x7F2CC8C92DC2746A,
         0x325B15E575E1C3D0, 0x8175595B76469CBF, 0xC6DF23B2DDA1638B, 0x75F16F0CDE063CE4, 0x498BD6618A6E9DE3,
         0xFAA59ADF89C9C28C, 0xBD0FE036222E3DB8, 0x0E21AC88218962D7, 0xC5FA92EC8AFF7FB6, 0x76D4DE52895820D9,
         0x317EA4BB22BFDFED, 0x8250E80521188082, 0xBE2A516875702185, 0x0D041DD676D77EEA, 0x4AAE673FDD3081DE,
         0xF9802B81DE97DEB1, 0x4FC0B4DD24D2A599, 0xFCEEF8632775FAF6, 0xBB44828A8C9205C2, 0x086ACE348F355AAD,
         0x34107759DB5DFBAA, 0x873E3BE7D8FAA4C5, 0xC094410E731D5BF1, 0x73BA0DB070BA049E, 0xB86133D4DBCC19FF,
         0x0B4F7F6AD86B4690, 0x4CE50583738CB9A4, 0xFFCB493D702BE6CB, 0xC3B1F050244347CC, 0x709FBCEE27E418A3,
         0x3735C6078C03E797, 0x841B8AB98FA4B8F8, 0xADDA7C5F3C4488E3, 0x1EF430E13FE3D78C, 0x595E4A08940428B8,
         0xEA7006B697A377D7, 0xD60ABFDBC3CBD6D0, 0x6524F365C06C89BF, 0x228E898C6B8B768B, 0x91A0C532682C29E4,
         0x5A7BFB56C35A3485, 0xE955B7E8C0FD6BEA, 0xAEFFCD016B1A94DE, 0x1DD181BF68BDCBB1, 0x21AB38D23CD56AB6,
         0x9285746C3F7235D9, 0xD52F0E859495CAED, 0x6601423B97329582, 0xD041DD676D77EEAA, 0x636F91D96ED0B1C5,
         0x24C5EB30C5374EF1, 0x97EBA78EC690119E, 0xAB911EE392F8B099, 0x18BF525D915FEFF6, 0x5F1528B43AB810C2,
         0xEC3B640A391F4FAD, 0x27E05A6E926952CC, 0x94CE16D091CE0DA3, 0xD3646C393A29F297, 0x604A2087398EADF8,
         0x5C3099EA6DE60CFF, 0xEF1ED5546E415390, 0xA8B4AFBDC5A6ACA4, 0x1B9AE303C601F3CB, 0x56ED3E2F9E224471,
         0xE5C372919D851B1E, 0xA26908783662E42A, 0x114744C635C5BB45, 0x2D3DFDAB61AD1A42, 0x9E13B115620A452D,
         0xD9B9CBFCC9EDBA19, 0x6A978742CA4AE576, 0xA14CB926613CF817, 0x1262F598629BA778, 0x55C88F71C97C584C,
         0xE6E6C3CFCADB0723, 0xDA9C7AA29EB3A624, 0x69B2361C9D14F94B, 0x2E184CF536F3067F, 0x9D36004B35545910,
         0x2B769F17CF112238, 0x9858D3A9CCB67D57, 0xDFF2A94067518263, 0x6CDCE5FE64F6DD0C, 0x50A65C93309E7C0B,
         0xE388102D33392364, 0xA4226AC498DEDC50, 0x170C267A9B79833F, 0xDCD7181E300F9E5E, 0x6FF954A033A8C131,
         0x28532E49984F3E05, 0x9B7D62F79BE8616A, 0xA707DB9ACF80C06D, 0x14299724CC279F02, 0x5383EDCD67C06036,
         0xE0ADA17364673F59]

}
