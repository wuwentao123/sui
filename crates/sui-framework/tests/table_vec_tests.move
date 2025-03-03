// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module sui::table_vec_tests {
    use sui::table_vec;
    use sui::test_scenario as ts;

    const TEST_SENDER_ADDR: address = @0x1;

    #[test]
    fun simple_all_functions() {
        let scenario = ts::begin(TEST_SENDER_ADDR);    

        let table_vec = table_vec::empty<u64>(ts::ctx(&mut scenario));
        assert!(table_vec::length(&table_vec) == 0, 0);

        table_vec::push_back(&mut table_vec, 7);
        let mut_value = table_vec::borrow_mut(&mut table_vec, 0);
        *mut_value = *mut_value + 1;
        let value = table_vec::borrow(&table_vec, 0);
        assert!(*value == 8, 0);

        table_vec::pop_back(&mut table_vec);
        table_vec::destroy_empty(table_vec);
        ts::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = sui::table_vec::ETABLE_NONEMPTY)]
    fun destroy_non_empty_aborts() {
        let scenario = ts::begin(TEST_SENDER_ADDR);
        let table_vec = table_vec::singleton(1, ts::ctx(&mut scenario));
        table_vec::destroy_empty(table_vec);
        ts::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = sui::table_vec::EINDEX_OUT_OF_BOUND)]
    fun pop_back_empty_aborts() {
        let scenario = ts::begin(TEST_SENDER_ADDR);
        let table_vec = table_vec::empty<u64>(ts::ctx(&mut scenario));
        table_vec::pop_back(&mut table_vec);
        table_vec::destroy_empty(table_vec);    
        ts::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = sui::table_vec::EINDEX_OUT_OF_BOUND)]
    fun borrow_out_of_bounds_aborts() {
        let scenario = ts::begin(TEST_SENDER_ADDR);
        let table_vec = table_vec::singleton(1, ts::ctx(&mut scenario));
        let _ = table_vec::borrow(&table_vec, 77);
        table_vec::destroy_empty(table_vec);
        ts::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = sui::table_vec::EINDEX_OUT_OF_BOUND)]
    fun borrow_mut_out_of_bounds_aborts() {
        let scenario = ts::begin(TEST_SENDER_ADDR);
        let table_vec = table_vec::singleton(1, ts::ctx(&mut scenario));
        let _ = table_vec::borrow_mut(&mut table_vec, 77);
        table_vec::destroy_empty(table_vec);
        ts::end(scenario);
    }
}
