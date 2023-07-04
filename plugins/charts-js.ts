import { Chart, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, LineElement, PointElement, ArcElement } from 'chart.js';
import { defineNuxtPlugin } from '#app';
import { Bar, Doughnut, Line, Bubble } from 'vue-chartjs';
import corn from "../corn";

export default defineNuxtPlugin((nuxtApp) => {
  Chart.register(
    Title,
    Tooltip,
    Legend,
    BarElement,
    CategoryScale,
    LinearScale,
    LineElement,
    PointElement,
    ArcElement,
    LinearScale,
    PointElement
  );

  // Global configuration
  // ChartJS error
  Chart.defaults.backgroundColor = [ corn.colors.primary, corn.colors.primary500, corn.colors.primary600, corn.colors.primary700, corn.colors.primary800, corn.colors.primary900 ];
  Chart.defaults.borderColor = corn.colors.gris200;
  Chart.defaults.color = corn.colors.gris500;
  Chart.defaults.font.family = corn.style.font;

  // tooltips
  Chart.defaults.plugins.tooltip.cornerRadius = parseFloat(corn.style.borderRadius);
  Chart.defaults.plugins.tooltip.padding = 12;

  // legends
  Chart.defaults.plugins.legend.labels.usePointStyle = true;
  Chart.defaults.plugins.legend.position = `bottom`;
  Chart.defaults.plugins.legend.labels.padding = 20;

  // bar
  Chart.defaults.elements.bar.borderRadius = parseFloat(corn.style.borderRadius);

  // line
  Chart.defaults.elements.line.borderColor = corn.colors.primary;

  nuxtApp.vueApp.component(`Bar`, Bar);
  nuxtApp.vueApp.component(`Doughnut`, Doughnut);
  nuxtApp.vueApp.component(`Line`, Line);
  nuxtApp.vueApp.component(`Bubble`, Bubble);
});