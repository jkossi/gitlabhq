import MemoryGraph from '../../vue_shared/components/memory_graph';

export default {
  name: 'MRWidgetMemoryUsage',
  props: {
    memoryFrom: { type: Number, required: true },
    memoryTo: { type: Number, required: true },
  },
  computed: {
    memoryMetrics() {
      return [
        [
          1490870055.525,
          '4.90234375',
        ],
        [
          1490870115.525,
          '4.90234375',
        ],
        [
          1490870175.525,
          '4.90234375',
        ],
        [
          1490870235.525,
          '4.658203125',
        ],
        [
          1490870295.525,
          '4.53125',
        ],
        [
          1490870355.525,
          '4.53125',
        ],
        [
          1490870415.525,
          '4.53125',
        ],
        [
          1490870475.525,
          '4.53125',
        ],
        [
          1490870535.525,
          '3.853515625',
        ],
        [
          1490870595.525,
          '4.60546875',
        ],
        [
          1490870655.525,
          '4.60546875',
        ],
        [
          1490870715.525,
          '4.60546875',
        ],
        [
          1490870775.525,
          '4.60546875',
        ],
        [
          1490870835.525,
          '4.93359375',
        ],
        [
          1490870895.525,
          '4.93359375',
        ],
        [
          1490870955.525,
          '4.93359375',
        ],
        [
          1490871015.525,
          '4.93359375',
        ],
        [
          1490871075.525,
          '4.93359375',
        ],
        [
          1490871135.525,
          '4.93359375',
        ],
        [
          1490871195.525,
          '4.93359375',
        ],
        [
          1490871255.525,
          '4.93359375',
        ],
        [
          1490871315.525,
          '4.93359375',
        ],
        [
          1490871375.525,
          '4.93359375',
        ],
        [
          1490871435.525,
          '4.93359375',
        ],
        [
          1490871495.525,
          '4.93359375',
        ],
        [
          1490871555.525,
          '4.93359375',
        ],
        [
          1490871615.525,
          '4.93359375',
        ],
      ];
    },
  },
  components: {
    'mr-memory-graph': MemoryGraph,
  },
  template: `
    <section class="mr-info-list mr-memory-usage">
      <div class="legend"></div>
      <p class="usage-info">Memory increased from {{memoryFrom}}MB to {{memoryTo}}MB.</p>
      <mr-memory-graph :height=25 :width=100 :metrics="memoryMetrics"></mr-memory-graph>
    </section>
  `,
};
