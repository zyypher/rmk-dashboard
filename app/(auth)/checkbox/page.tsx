'use client'

import PageHeading from '@/components/layout/page-heading'
import { Checkbox } from '@/components/ui/checkbox'
import { RadioGroup, RadioGroupItem } from '@/components/ui/radio-group'
import { Switch } from '@/components/ui/switch'

export default function CheckBox() {
    return (
        <div className="space-y-4">
            <PageHeading heading={'Check Box & Radio Buttons'} />

            <div className="min-h-[calc(100vh_-_160px)]">
                <div className="grid gap-4 sm:grid-cols-3 lg:grid-cols-4">
                    {/* Default Checkboxes */}
                    <div className="rounded-lg bg-white">
                        <div className="border-b bg-gray-200 px-4 py-3 font-semibold text-black">
                            Check Box
                        </div>
                        <div className="space-y-2.5 px-4 py-3">
                            <label className="flex items-center gap-2">
                                <Checkbox />
                                <span className="text-xs font-semibold text-black">
                                    Default checkbox
                                </span>
                            </label>
                            <label className="flex items-center gap-2">
                                <Checkbox defaultChecked />
                                <span className="text-xs font-semibold text-black">
                                    Checked checkbox
                                </span>
                            </label>
                        </div>
                    </div>

                    {/* Disabled Checkboxes */}
                    <div className="rounded-lg bg-white">
                        <div className="border-b bg-gray-200 px-4 py-3 font-semibold text-black">
                            Disabled
                        </div>
                        <div className="space-y-2.5 px-4 py-3">
                            <label className="flex items-center gap-2">
                                <Checkbox disabled />
                                <span className="text-xs font-semibold text-black opacity-50">
                                    Disabled checkbox
                                </span>
                            </label>
                            <label className="flex items-center gap-2">
                                <Checkbox checked disabled />
                                <span className="text-xs font-semibold text-black opacity-50">
                                    Disabled checked
                                </span>
                            </label>
                        </div>
                    </div>

                    {/* Default Radios */}
                    <div className="rounded-lg bg-white">
                        <div className="border-b bg-gray-200 px-4 py-3 font-semibold text-black">
                            Radio
                        </div>
                        <RadioGroup
                            className="gap-2.5 px-4 py-3"
                            defaultValue="Default"
                        >
                            <label className="flex items-center gap-2.5">
                                <RadioGroupItem value="Default" />
                                <span className="text-xs font-semibold text-black">
                                    Default radio
                                </span>
                            </label>
                            <label className="flex items-center gap-2.5">
                                <RadioGroupItem
                                    value="DefaultChecked"
                                    defaultChecked
                                />
                                <span className="text-xs font-semibold text-black">
                                    Checked radio
                                </span>
                            </label>
                        </RadioGroup>
                    </div>

                    {/* Disabled Radios */}
                    <div className="rounded-lg bg-white">
                        <div className="border-b bg-gray-200 px-4 py-3 font-semibold text-black">
                            Disabled Radios
                        </div>
                        <RadioGroup className="gap-2.5 px-4 py-3" disabled>
                            <label className="flex items-center gap-2.5">
                                <RadioGroupItem value="Disabled" disabled />
                                <span className="text-xs font-semibold text-black opacity-50">
                                    Disabled
                                </span>
                            </label>
                            <label className="flex items-center gap-2.5">
                                <RadioGroupItem
                                    value="CheckedDisabled"
                                    disabled
                                    defaultChecked
                                />
                                <span className="text-xs font-semibold text-black opacity-50">
                                    Checked disabled
                                </span>
                            </label>
                        </RadioGroup>
                    </div>

                    {/* Toggle Switches */}
                    <div className="rounded-lg bg-white">
                        <div className="border-b bg-gray-200 px-4 py-3 font-semibold text-black">
                            Switches
                        </div>
                        <div className="space-y-2.5 px-4 py-3">
                            <label className="flex items-center gap-2">
                                <Switch />
                                <span className="text-xs font-semibold text-black">
                                    Default
                                </span>
                            </label>
                            <label className="flex items-center gap-2">
                                <Switch className="data-[state=checked]:bg-blue-500" />
                                <span className="text-xs font-semibold text-black">
                                    Blue
                                </span>
                            </label>
                            <label className="flex items-center gap-2">
                                <Switch className="data-[state=checked]:bg-green-500" />
                                <span className="text-xs font-semibold text-black">
                                    Success
                                </span>
                            </label>
                            <label className="flex items-center gap-2">
                                <Switch className="data-[state=checked]:bg-yellow-500" />
                                <span className="text-xs font-semibold text-black">
                                    Warning
                                </span>
                            </label>
                            <label className="flex items-center gap-2">
                                <Switch className="data-[state=checked]:bg-red-500" />
                                <span className="text-xs font-semibold text-black">
                                    Danger
                                </span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}
