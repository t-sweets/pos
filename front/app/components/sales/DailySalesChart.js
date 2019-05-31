import { Bar } from 'vue-chartjs'

export default {
  extends: Bar,
  props: ['data', 'options'],
  methods: {
    reload() {
      this.renderChart(this.data, this.options)
    }
  },
  mounted() {
    this.renderChart(this.data, this.options)
  }
}