import { DefaultConfigOptions, createInput } from "@formkit/vue";
import { generateClasses } from "@formkit/themes";
import { fr } from '@formkit/i18n';
import corn from '~/corn';

import InputPasswordStrong from "~/components/corn/forms/InputPasswordStrong.vue";

// https://formkit.com/inputs/color#sections

/** START: formkit custom rules */
const strongPassword = (node: any): boolean => {
  let isRuleValid = false;
  if (node.value) {
    isRuleValid = !!node.value.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[`~!@#$%^&*()_|+\-=?;:'",.<>{}[\]\\/])(?!.+ ).{8,32}$/);
  }
  return isRuleValid;
};
strongPassword.skipEmpty = false;

/** END: formkit custom rules */

const config: DefaultConfigOptions = {
  locales: { fr },
  locale: `fr`,
  plugins: [handleSchemaErrors, addAsteriskPlugin],
  rules: { strongPassword },
  config: {
    classes: generateClasses({
      global: {
        outer: `my-5`,
        label: `block text-gray-600 text-sm font-bold mb-2`,
        inner: ``,
        input: `border rounded-corn w-full py-2 px-3 text-gray-700 leading-tight focus:outline-primary focus:shadow-outline`,
        help: `text-xs text-gray-500`,
        messages: `list-none p-0 mt-1 mb-0 `,
        message: `mb-1 text-xs text-danger-300`,
        wrapper: ``
      },

      checkbox: {
        input: `w-auto`,
        wrapper: `flex items-center gap-2`,
        label: `!mb-0`
      },
      color: {
        input: `py-0 px-0 border-0 bg-transparent `
      },
      radio: {
        wrapper: `flex gap-2 items-center`,
        label: `mb-0`,
        options: `mt-2`
      },
      button: {
        input: `corn-button-primary disabled:bg-gray-300`
      },
      submit: {
        outer: `$reset`,
        input: `$reset corn-button-primary disabled:bg-gray-300`
      }
    })
  },
  messages: {
    fr: {
      validation: {}
    }
  },
  inputs: {
    passwordStrong: createInput(InputPasswordStrong, {
      type: `input`,
      props: [
        `placeholder`
      ]
    })
  }
};

function handleSchemaErrors(node: any) {
  if (!node.props.definition) {
    throw corn.error.generateError(`unknown input type: ${node.context.type}`);
  }
}

function addAsteriskPlugin(node: any) {
  node.on(`created`, () => {
    const schemaFn = node.props.definition.schema;
    node.props.definition.schema = (sectionsSchema: any = {}) => {
      const isRequired = node.props.parsedRules.some((rule: any) => rule.name === `required`);
      if (isRequired) {
        if ((node.props.type === `checkbox` || node.props.type === `radio`) && node.props.options) {
          sectionsSchema.legend = {
            children: [`$label `, ` *`]
          };
        } else {
          sectionsSchema.label = {
            children: [`$label `, ` *`]
          };
        }
      }
      return schemaFn(sectionsSchema);
    };
  });
}

export default config;