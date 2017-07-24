#pragma once

#include <cstdint>
#include <unordered_map>

#include "envoy/thread_local/thread_local.h"

#include "test/mocks/event/mocks.h"

#include "gmock/gmock.h"

namespace Envoy {
namespace ThreadLocal {

class MockSlot : public Slot {};

class MockInstance : public Instance {
public:
  MockInstance();
  ~MockInstance();

  // Server::ThreadLocal
  MOCK_METHOD0(allocateSlot, SlotPtr());
  // MOCK_METHOD1(get, ThreadLocalObjectSharedPtr(uint32_t index));
  MOCK_METHOD2(registerThread, void(Event::Dispatcher& dispatcher, bool main_thread));
  MOCK_METHOD1(runOnAllThreads, void(Event::PostCb cb));
  // MOCK_METHOD2(set, void(uint32_t index, InitializeCb cb));
  MOCK_METHOD0(shutdownThread, void());

  // uint32_t allocateSlot_() { return current_slot_++; }
  ThreadLocalObjectSharedPtr get_(uint32_t index) { return data_[index]; }
  void runOnAllThreads_(Event::PostCb cb) { cb(); }
  // void set_(uint32_t index, InitializeCb cb) { data_[index] = cb(dispatcher_); }
  /*void shutdownThread_() {
    for (auto& entry : data_) {
      entry.second->shutdown();
    }
  }*/

  testing::NiceMock<Event::MockDispatcher> dispatcher_;
  std::vector<ThreadLocalObjectSharedPtr> data_;
};

} // namespace ThreadLocal
} // namespace Envoy
