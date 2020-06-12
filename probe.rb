#!/usr/bin/env ruby
# frozen_string_literal: true

VAIRE_ENDPOINT = "#{ENV.fetch('VAIRE_URL')}/messages"

BASE_PAYLOAD = {
  data: {
    type: :states,
    attributes: {}
  }
}.freeze

def cpu_from_snapshot(snap)
  {
    idle: snap.cpus.first.idle,
    system: snap.cpus.first.system,
    user: snap.cpus.first.user,
    nice: snap.cpus.first.nice
  }
end

def data_from_snapshot
  snap = Vmstat.snapshot
  {
    load: snap.load_average.one_minute,
    memory: {
      free: snap.memory.free
    },
    cpu: cpu_from_snapshot(snap)
  }
end

def send_telemetry(attr)
  payload = BASE_PAYLOAD.dup
  payload[:data][:attributes] = attr
  Typhoeus.post(VAIRE_ENDPOINT,
                body: payload,
                headers: { 'X-VAIRE-TOKEN' => 'ainunindale' })
end

def perform
  attrs = {
    service: SVCS.sample,
    machine: MACS.sample,
    summary: :ok,
    stats: data_from_snapshot,
    ocurred_at: Time.now.utc
  }
  send_telemetry(attrs)
end

perform
